require "rotten"
require "tmdb"
require 'amazon/ecs'

class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  
  def index 
   
    @movies = Movie.all(:limit => 25)
    @show_array = TvShow.all(:limit => 25)
    @your_picks = Array.new
    @movie = @movies[0]
    
    
    # puts the entire array onto the end of the your picks 
    @your_picks.push(*@movies)
    @your_picks.push(*@show_array)
    
  end
  
  def details
    # This is a placeholder - users will be redirected to it when they are signed in, for now
    # alternatively,
    Amazon::Ecs.configure do |options|
      options[:associate_tag] = 'Spudsy Devs'
      options[:AWS_access_key_id] = 'AKIAIKFAMUN6RODAOVKA'
      options[:AWS_secret_key] = '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'
    end

    # options provided on method call will merge with the default options
    res = Amazon::Ecs.item_search('Seinfeld', {:response_group => 'Medium', :sort => 'salesrank'})
    @res = res
    @total_pages = @res.total_pages
    @first = @res.items.first
  end
  
  private 
  
    # put private methods here
end
