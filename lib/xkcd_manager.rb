require 'xkcd'
require 'pry'

module XkcdManager
  def self.random_image
    XKCD.img
  end

  def self.search_image query
    XKCD.search query
  end
end
