require 'test_helper'

class FriendFinderTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::FriendFinder::VERSION
  end

  def test_find_with_a_provider_returns_an_instance_of_that_finder
    assert_kind_of FriendFinder::Twitter, FriendFinder.find(:twitter, :oauth_token => 'abcd', :oauth_token_secret => '1234')
  end

  def test_find_with_an_unknown_provider_returns_nil
    assert_nil FriendFinder.find(:foobar)
  end

end
