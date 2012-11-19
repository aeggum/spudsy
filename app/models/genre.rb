class Genre < ActiveRecord::Base
  attr_accessible :name, :genre
  validates :name, :presence => :true
  has_many :media_genres
  has_many :media, :through => :media_genres
end
