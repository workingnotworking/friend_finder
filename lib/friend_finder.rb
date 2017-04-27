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
  def self.find(provider, options={})
    const_get("FriendFinder::#{provider.to_s.capitalize}").new(options)
  # rescue NameError => e
  #   nil
  end

end
