require 'twitter'

module FriendFinder

  PER_PAGE = 200
  DEFAULT_PAGE = -1

  class Twitter

    attr_reader :options, :client

    def initialize(options={})
      @options = options
      @next = nil
      @client ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = FriendFinder.config.twitter[:key]
        config.consumer_secret     = FriendFinder.config.twitter[:secret]
        config.access_token        = options[:oauth_token]
        config.access_token_secret = options[:oauth_token_secret]
      end
    end

    # returns an array of twitter usernames
    def data(data_options={})
      friends(data_options).instance_variable_get(:@collection).collect { |u| { u.id => u.screen_name } }
    end

    def ids
      data.collect { |pair| pair.keys.first }
    end

    def usernames
      data.collect { |pair| pair.values.first }
    end

    def next_page
      @next_page ||= friends.attrs[:next_cursor].zero? ? nil : friends.attrs[:next_cursor]
    end

    # returns the cursor object that contains the friends
    private def friends(data_options={})
      @friends ||= client.friends(client_options(data_options))
    rescue ::Twitter::Error::Forbidden => e
      raise FriendFinder::MissingAuthentication
    rescue ::Twitter::Error::Unauthorized => e
      raise FriendFinder::Unauthorized
    rescue ::Twitter::Error::TooManyRequests
      raise FriendFinder::RateLimit
    end

    private def client_options(data_options={})
      {
        :skip_status => true,
        :count => PER_PAGE,
        :cursor => options[:page] || DEFAULT_PAGE
      }.merge(data_options)
    end

  end
end
