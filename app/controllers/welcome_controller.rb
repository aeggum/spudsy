require 'assets/rotten_tomatoes'
class WelcomeController < ApplicationController
  include RottenTomatoes
  def index
    # I think this can essentially be the landing page
    RottenTomatoes::Rotten.full_movie_info(770672122) 
    RottenTomatoes::Rotten.movie_reviews(770672122, 20, 1, 'us')
    RottenTomatoes::Rotten.top_rentals(5, 'us');
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
  end
end
