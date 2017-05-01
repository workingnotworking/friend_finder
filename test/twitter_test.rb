require 'test_helper'

class TwitterTest < Minitest::Test

  def setup
    FriendFinder.configure do |config|
      config.twitter = { :key => 'foo', :secret => 'bar' }
    end
  end

  def test_initialzing_twitter
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')

    assert_equal 'abcd', client.options[:oauth_token]
    assert_equal '1234', client.options[:oauth_token_secret]
  end

end
