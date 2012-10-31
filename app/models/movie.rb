class Movie < ActiveRecord::Base
  
  #Validates the follow are present before saving in the database
  validates :rating, :name, :release_date, :presence => true
  
  attr_accessible :description, :name, :rating, :release_date
  has_many :actors, :as => :media
end
