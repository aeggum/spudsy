require "rotten"
require "ruby-tmdb"

class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb.default_language = "en"
  
  def index 
   
    # Doing some testing with the RT API wrapper
    argo = Rotten::Movie.find_first "Argo"
    @argo_score = argo.ratings['critics_score']
    
    perks = Rotten::Movie.find_first "Perks of being a wallflower"
    @perks_score = perks.ratings['critics_score']
    @perks_poster = perks.posters['detailed']
    
    @movie = TmdbMovie.find :title => "Argo", :limit => 1
    puts @movie.id
    
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
  end
end
