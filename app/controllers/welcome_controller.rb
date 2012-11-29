require "rotten"
require "tmdb"
require 'amazon/ecs'

class WelcomeController < ApplicationController
  Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
  Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
  Tmdb::Tmdb.default_language = "en"
  
  caches_action :get_shows
  def index 
   
    @movies = Movie.all(:limit => 25)
    @show_array = get_shows 
    @your_picks = Array.new
    
    
    # puts the entire array onto the end of the your picks 
    @your_picks.push(*@movies)
    @your_picks.push(*@show_array)
    
    
    # Doing some testing with the RT API wrapper
    # argo = Rotten::Movie.find_first "Argo"
    @argo_score = @movies[0].rating #argo.ratings['critics_score']
    @argo_poster = @movies[0].poster #argo.posters['detailed']
    
    # perks = Rotten::Movie.find_first "Perks of being a wallflower"
    @perks_score = @movies[1].rating #perks.ratings['critics_score']
    @perks_poster = @movies[1].poster #perks.posters['detailed']
    
    # looper = Rotten::Movie.find_first "Looper"
    @looper_score = @movies[2].rating #looper.ratings['critics_score']
    @looper_poster = @movies[2].poster #looper.posters['detailed']
    
    # psychopaths = Rotten::Movie.find_first "Seven Psychopaths"
    @psycho_score = @movies[3].rating #psychopaths.ratings['critics_score']
    @psycho_poster = @movies[4].poster #psychopaths.posters['detailed']
    
    # dark_rises = Rotten::Movie.find_first "The Dark Knight Rises"
    @rises_score = @movies[4].rating #dark_rises.ratings['critics_score']
    @rises_poster = @movies[4].poster #dark_rises.posters['detailed']
    
    # avatar = Rotten::Movie.find_first "Avatar"
    @avatar_score =  @movies[5].rating #avatar.ratings['critics_score']
    @avatar_poster = @movies[5].poster #avatar.posters['detailed']
    
    
    
    
    # extra movies (hard-coded) (page 2)
    # dark_knight = Rotten::Movie.find_first "The Dark Knight"
    @dark_knight_score =  @movies[6].rating
    @dark_knight_poster = @movies[6].poster
    
    # cruel_intentions = Rotten::Movie.find_first "Cruel Intentions"
    @cruel_score =  @movies[7].rating
    @cruel_poster = @movies[7].poster
    
    # avengers = Rotten::Movie.find_first "The Avengers"
    @avengers_score =  @movies[8].rating
    @avengers_poster = @movies[8].poster
    
    # cloud = Rotten::Movie.find_first "Cloud Atlas"
    @cloud_score =  @movies[9].rating
    @cloud_poster = @movies[9].poster
    
    # harry_potter = Rotten::Movie.find_first "Harry Potter"
    @potter_score =  @movies[10].rating
    @potter_poster = @movies[10].poster
    
    # iron_man = Rotten::Movie.find_first "Iron Man"
    @iron_score =  @movies[11].rating
    @iron_poster = @movies[11].poster
    
    
    
    # page 3 
    # spiderman = Rotten::Movie.find_first "Spiderman"
    @spiderman_score =  @movies[12].rating
    @spiderman_poster = @movies[12].poster
    
    # titanic = Rotten::Movie.find_first "Titanic"
    @titanic_score =  @movies[13].rating
    @titanic_poster = @movies[13].poster
    
    # texas = Rotten::Movie.find_first "The Texas Chainsaw Massacre"
    @texas_score =  @movies[14].rating
    @texas_poster = @movies[14].poster
    
    # legend = Rotten::Movie.find_first "I am Legend"
    @legend_score =  @movies[15].rating
    @legend_poster = @movies[15].poster
    
    # lotr = Rotten::Movie.find_first "Lord of the Rings"
    @lotr_score =  @movies[16].rating
    @lotr_poster = @movies[16].poster
    
    
    
    
    # will print out a giant blob in the console
    # @movie = Tmdb::TmdbMovie.find :title => "Argo", :limit => 1
    # puts @movie.id
    # puts @movie # tons of information
    # puts @movie.title
    # puts @movie.overview
    # puts @movie.release_date
    # @rt_movie = Rotten::Movie.find_first(@movie.title);
    # puts @rt_movie
    # puts @rt_movie.ratings['critics_score']
    # puts @rt_movie.ratings['audience_score']
    # puts @rt_movie.mpaa_rating
    
    
    # This is an example of how to add one Movie to the database.  Need to do this for thousands.. and not in an action
    # movie = Movie.new(:name => @movie.name, :description => @movie.overview, :release_date => @movie.released, :rating => Rotten::Movie.find_first(@movie.name).ratings['critics_score'])
    #movie.save!
    
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
  
    def get_shows
      # tvdb = TvdbParty::Search.new("FACBC9B54A326107")
      # tv_show_titles = ['Seinfeld', 'The West Wing', 'Person of Interest', 'The Walking Dead', '24', #'Family Guy', 
          # 'Dexter', 'Breaking Bad', 'Planet Earth', 'The Wire', 'Game of Thrones', 'Arrested Development', 'Firefly', 
          # 'Lost', 'The Sopranos', 'Sherlock', 'Twin Peaks', 'Batman', 'Oz', 'Downton Abbey', 'Top Gear'] #,'Rome'
      # show_array = Array.new
      # tv_show_titles.each { |show|
        # hash_show = Hash.new
        # hash_show['title'] = show
        # tvdb_show = tvdb.get_series_by_id(tvdb.search(show)[0]["seriesid"])
        # hash_show['rating'] = tvdb_show.rating
        # hash_show['poster'] = tvdb_show.posters('en').first.url
        # # puts show
        # show_array.push(hash_show)
      # }
    
        
      return TvShow.all
    end
end
