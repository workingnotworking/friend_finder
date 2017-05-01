require 'test_helper'

class TwitterTest < Minitest::Test

  def setup
    FriendFinder.configure do |config|
      config.twitter = { :key => 'foo', :secret => 'bar' }
    end
    friends = stub('friends', :attrs => { :next_cursor => 12345 })
    friends.instance_variable_set(:@collection, [stub('user', :id => 1234, :screen_name => 'foobar')])

    ::Twitter::REST::Client.any_instance.stubs(:friends => friends)
  end

  def test_initialzing_twitter
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')

    assert_equal 'abcd', client.options[:oauth_token]
    assert_equal '1234', client.options[:oauth_token_secret]
  end

  def test_instance_variable_next_returns_the_next_cursor
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')
    client.data

    assert_equal 12345, client.next
  end

  def test_collection_returns_a_hash_of_id_to_username
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')

    assert_equal([1234 => 'foobar'], client.data)
  end

  def test_ids_returns_only_the_ids
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')

    assert_equal([1234], client.ids)
  end

  def test_usernames_returns_only_the_usernames
    client = FriendFinder::Twitter.new(:oauth_token => 'abcd', :oauth_token_secret => '1234')

    assert_equal(['foobar'], client.usernames)
  end

end
