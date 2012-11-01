require "rotten"
require "tmdb"

class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  
  def index 
   
    # Doing some testing with the RT API wrapper
    argo = Rotten::Movie.find_first "Argo"
    @argo_score = argo.ratings['critics_score']
    
    perks = Rotten::Movie.find_first "Perks of being a wallflower"
    @perks_score = perks.ratings['critics_score']
    @perks_poster = perks.posters['detailed']
    
    # will print out a giant blob in the console
    @movie = Tmdb::TmdbMovie.find :title => "Argo", :limit => 1
    puts @movie.id
    puts @movie # tons of information
    puts @movie.title
    puts @movie.overview
    puts @movie.release_date
    @rt_movie = Rotten::Movie.find_first(@movie.title);
    puts @rt_movie
    puts @rt_movie.ratings['critics_score']
    puts @rt_movie.ratings['audience_score']
    puts @rt_movie.mpaa_rating
    
    
    # This is an example of how to add one Movie to the database.  Need to do this for thousands.. and not in an action
    # movie = Movie.new(:name => @movie.name, :description => @movie.overview, :release_date => @movie.released, :rating => Rotten::Movie.find_first(@movie.name).ratings['critics_score'])
    #movie.save!
    
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
  end
end
