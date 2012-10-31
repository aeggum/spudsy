class Movie < ActiveRecord::Base
  belongs_to :actor
  attr_accessible :description, :name, :rating, :release_date
end
