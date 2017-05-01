require 'twitter'

module FriendFinder

  PER_PAGE = 200
  DEFAULT_PAGE = -1

  class Twitter

    attr_reader :identity, :options, :next, :client

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

    # whether we're at the end of the list
    def last_page?
      @next.zero?
    end

    # TODO: add caching for a certain number of minutes so that users opening the connections list multiple times doesn't count against rate limit
    # returns the cursor object that contains the friends
    private def friends(data_options={})
      output = client.friends(client_options(data_options))
      @next = output.attrs[:next_cursor]
      output
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
