require 'open-uri'
require 'nokogiri'
require 'pry'

module Imgur
  def self.booty
    get_random_from_subimgur 'booty'
  end

  def self.pussy
    get_random_from_subimgur 'pussy'
  end

  def self.black_people_twitter
    get_random_from_subimgur 'blackpeopletwitter'
  end

  def self.futanari
    get_random_from_subimgur 'futanari'
  end

  def self.gaybro
    get_random_from_subimgur 'GaybrosGoneWild'
  end

  def self.lady_boys
    get_random_from_subimgur 'ladyboys'
  end

  def self.get_random_from_subimgur subimgur
    doc = Nokogiri::HTML(open("http://www.imgur.com/r/#{subimgur}"))
    results = doc.css(".post .image-list-link img")

    ind = Random.new.rand(results.length)

    image_id, extension = results[ind].attributes['src'].value.split('/').last.split('.')
    image_id = image_id[0..-2]

    "https://imgur.com/#{image_id}.#{extension}"
  end
end
