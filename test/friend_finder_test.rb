require 'test_helper'

class FriendFinderTest < Minitest::Test

  def setup
    FriendFinder.configure do |config|
      config.twitter = { :key => 'foo', :secret => 'bar' }
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::FriendFinder::VERSION
  end

  def test_that_configure_saves_config_info
    FriendFinder.configure do |config|
      config.twitter = { :foo => 'bar' }
    end

    assert_equal({ :foo => 'bar' }, FriendFinder.config.twitter)
  end

  def test_provider_to_class_name_camelizes_providers
    assert_equal 'Twitter', FriendFinder.provider_to_class_name(:twitter)
    assert_equal 'Twitter', FriendFinder.provider_to_class_name('twitter')
    assert_equal 'FooBar', FriendFinder.provider_to_class_name(:foo_bar)
    assert_equal 'FooBar', FriendFinder.provider_to_class_name('foo_bar')
  end

  def test_find_with_a_provider_returns_an_instance_of_that_finder
    assert_kind_of FriendFinder::Twitter, FriendFinder.finder(:twitter,
      :oauth_token => 'abcd', :oauth_token_secret => '1234')
  end

  def test_find_with_an_unknown_provider_raises_an_error
    skip
  end

end
