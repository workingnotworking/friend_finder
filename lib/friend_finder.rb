require 'friend_finder/version'
require 'friend_finder/twitter'

module FriendFinder

  # The main interface to the gem. Call this along with the provider and any
  # options to be passed through to the individual strategy.
  #
  #   FriendFinder.find(:twitter,
  #     :oauth_token => 'zyxw', :oauth_token_secret => '0987',
  #     :twitter => { :key => 'abcd', :secret => '1234' }
  #   )
  #
  def self.finder(provider, options={})
    klass = provider_to_class_name(provider)
    finder = begin
      const_get("FriendFinder::#{klass}")
    rescue
      nil
    end
    options = scrub_options(options)
    finder.new(options) if finder
  end

  def self.provider_to_class_name(provider)
    string = provider.to_s.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

  def self.scrub_options(options)
    options.delete(:page) if page.nil
    options
  end

end
