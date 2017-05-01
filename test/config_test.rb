require 'test_helper'

class ConfigTest < Minitest::Test

  def test_that_twitter_credientials_are_saved
    config = FriendFinder::Config.new
    config.twitter = { :foo => 'bar' }

    assert_equal({ :foo => 'bar' }, config.twitter)
  end

end
