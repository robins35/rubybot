require 'active_record'

class ImgurCommand < ActiveRecord::Base
  validates_uniqueness_of :command

  def get_random_from_subimgur
    doc = Nokogiri::HTML(open(full_subimgur_url))
    results = doc.css(".post .image-list-link img")

    ind = Random.new.rand(results.length)

    image_id, extension = results[ind].attributes['src'].value.split('/').last.split('.')
    image_id = image_id[0..-2]

    "https://imgur.com/#{image_id}.#{extension}"
  end

  def full_subimgur_url
    "http://www.imgur.com/r/#{subimgur}"
  end
end
