module FriendFinder
  class Config

    attr_accessor :twitter, :facebook, :instagram, :initialized

    def initialize
      @twitter = { :key => nil, :secret => nil }
      @facebook = {}
      @instagram = {}
    end

  end
end
