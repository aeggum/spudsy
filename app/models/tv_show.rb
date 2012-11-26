class TvShow < ActiveRecord::Base
  
  #validates that the following are present before saving to the DB
  validates :name, :rating, :presence => true
  
  attr_accessible :description, :name, :rating, :poster, :genres
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
end
