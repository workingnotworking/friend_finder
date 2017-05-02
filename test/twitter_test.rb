require 'test_helper'

class TwitterTest < Minitest::Test

  def setup
    FriendFinder.configure do |config|
      config.twitter = { :key => 'foo', :secret => 'bar' }
    end
    @next_cursor = 12345
    @token = SecureRandom.uuid
    @secret = SecureRandom.uuid

    friends = stub('friends', :attrs => { :next_cursor => @next_cursor })
    friends.instance_variable_set(:@collection, [stub('user', :id => 1234, :screen_name => 'foobar')])
    ::Twitter::REST::Client.any_instance.stubs(:friends => friends)

    @client = FriendFinder::Twitter.new(:oauth_token => @token, :oauth_token_secret => @secret)
  end

  def test_initialzing_twitter_saves_oauth_tokens
    assert_equal @token, @client.options[:oauth_token]
    assert_equal @secret, @client.options[:oauth_token_secret]
  end

  def test_next_page_returns_the_next_cursor
    assert_equal @next_cursor, @client.next_page
  end

  def test_next_page_of_zero_returns_nil
    friends = stub('friends', :attrs => { :next_cursor => 0 })
    friends.instance_variable_set(:@collection, [stub('user', :id => 1234, :screen_name => 'foobar')])
    ::Twitter::REST::Client.any_instance.stubs(:friends => friends)
    client = FriendFinder::Twitter.new(:oauth_token => @token, :oauth_token_secret => @secret)

    assert_nil client.next_page
  end

  def test_collection_returns_a_hash_of_id_to_username
    assert_equal([1234 => 'foobar'], @client.data)
  end

  def test_ids_returns_only_the_ids
    assert_equal([1234], @client.ids)
  end

  def test_usernames_returns_only_the_usernames
    assert_equal(['foobar'], @client.usernames)
  end

  def test_unauthorized_access_raises_a_friend_finder_error_instead
    ::Twitter::REST::Client.any_instance.expects(:friends).raises(::Twitter::Error::Unauthorized)
    client = FriendFinder::Twitter.new(:oauth_token => @token, :oauth_token_secret => @secret)

    assert_raises FriendFinder::Unauthorized do
      client.data
    end
  end

  def test_hitting_the_rate_limit_raises_a_friend_finder_error_instead
    ::Twitter::REST::Client.any_instance.expects(:friends).raises(::Twitter::Error::TooManyRequests)
    client = FriendFinder::Twitter.new(:oauth_token => @token, :oauth_token_secret => @secret)

    assert_raises FriendFinder::RateLimit do
      client.data
    end
  end

end
