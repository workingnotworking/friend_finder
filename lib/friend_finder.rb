require 'friend_finder/version'
require 'friend_finder/config'
require 'friend_finder/twitter'

module FriendFinder

  class Unauthorized < StandardError; end
  class RateLimit < StandardError; end

  class << self
    attr_reader :config

    def configure(&block)
      @config = FriendFinder::Config.new
      block.call(@config)
    end

    # The main interface to the gem. Call this along with the provider and any
    # options to be passed through to the individual strategy.
    #
    #   FriendFinder.find(:twitter,
    #     :oauth_token => 'zyxw', :oauth_token_secret => '0987',
    #     :twitter => { :key => 'abcd', :secret => '1234' }
    #   )
    #
    def finder(provider, options={})
      klass = provider_to_class_name(provider)
      finder = begin
        const_get("FriendFinder::#{klass}")
      # rescue
      #   nil
      end
      finder.new(options) if finder
    end

    def provider_to_class_name(provider)
      string = provider.to_s.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

  end

end
