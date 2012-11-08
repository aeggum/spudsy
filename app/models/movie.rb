class Movie < ActiveRecord::Base
  
  #Validates the follow are present before saving in the database
  validates :rating, :user_rating, :mpaa_rating, :name, :presence => true
  
  attr_accessible :description, :name, :rating, :user_rating, :mpaa_rating, :poster, :release_date
  has_many :actors, :as => :media
end
