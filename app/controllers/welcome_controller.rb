require "rotten"
class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  
  def index
    # I think this can essentially be the landing page
    # APIS::RottenTomatoes.full_movie_info(770672122) 
    # APIS::RottenTomatoes.movie_reviews(770672122, 20, 1, 'us')
    # APIS::RottenTomatoes.top_rentals(5, 'us');
    
    puts Rotten::Movie.upcoming
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
  end
end
