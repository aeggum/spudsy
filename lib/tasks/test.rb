require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require "../rotten.rb"
require "tmdb"
require 'pp'
include ActionView::Helpers::DateHelper

# TODO: This file should not be used any more.  Look for gen_movie and gen_tv
Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
Tmdb::Tmdb.default_language = "en"
movieArray = Array.new
movieTitles = Array.new

# TODO: Generate the seeds file with the top movies, or whatever.
# TODO: We'll want to do something similar to below, but put into seeds.rb

# file1 = File.open("test2.rb", "r+")
#   
# if file1
  # content = file1.sysread(10)
  # puts content
# else 
  # puts "Unable to open file!"
# end
# TODO: need to do a year check as well, then everything should be squared away
(121050..150000).each { |i| 
  # do something similar to what was done for tv shows
  movie_array = Array.new
  titles = Array.new
  overviews = Array.new
  genres = Array.new
  dates = Array.new
  popularities = Array.new
  
  begin 
    # something that does something
    movie = Tmdb::TmdbMovie.find(:id => i)
    if (movie.nil? || movie.empty?)
      next
    end
    
    # genre array gets one index for each movie
    unless movie.genres.nil?
      genre_arr = Array.new
      g_a = Array.new
      movie.genres.each { |genre| 
        genre_hash = { :name => genre.name }
        # unless genre_array.include?(genre_hash)
          # genre_array.push(genre_hash)
        # end 
        genre_arr.push(genre_hash)
        g_a.push(genre.name)
      }
      # genres.push(genre_arr)
      genres.push(g_a)
    end
   
    # TODO: Do I want to keep the TMDB id as well?
    titles.push(movie.original_title)
    overviews.push(movie.overview)
    dates.push(movie.release_date)
    popularities.push(movie.popularity)
    
    titles.each_with_index { |title, index|
      hash_movie = Hash.new
      hash_movie['name'] = title
      results = Rotten::Movie.search title
      
      rt_movie = nil
      results.each { |rt_mv| 
        if (rt_mv.title == title && rt_mv.release_dates['theater'][0,4] == dates[index][0,4] && rt_mv.posters['detailed'] != "http://images.rottentomatoescdn.com/images/redesign/poster_default.gif")
          rt_movie = rt_mv
          puts rt_movie.title
          break
        end
      }
      
      # if the movie is nil or hasn't been reviewed, it is not of any value to us
      if rt_movie.nil? || rt_movie.ratings['critics_score'] == -1 
        next
      end
      
      hash_movie['rating'] = rt_movie.ratings['critics_score']
      
      # boolean for certified fresh or not
      if (rt_movie.ratings['critics_rating'] == "Certified Fresh") 
        hash_movie['certified'] = true
      else 
        hash_movie['certified'] = false
      end
      
      hash_movie['user_rating'] = rt_movie.ratings['audience_score']
      hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
      
      # if the RT synopsis is empty, use the tmdb one
      if (rt_movie.synopsis.nil? || rt_movie.synopsis.empty?)
        hash_movie['description'] = overviews[index]
      else
        hash_movie['description'] = rt_movie.synopsis
      end
      
      hash_movie['popularity'] = popularities[index]
      hash_movie['poster'] = rt_movie.posters['detailed']
      hash_movie['release_date'] = rt_movie.release_dates['theater']
      hash_movie['rt_id'] = rt_movie.id
      hash_movie['runtime'] = rt_movie.runtime
      hash_movie['genres'] = genres[index]
      movie_array.push(hash_movie)
      File.open("official.movies.txt", "a") { |f| 
        f.puts(hash_movie) 
      }
    }
    
    
  rescue
    # caught exception
    if (i % 10 == 0) 
      print '.' #print '.'
    end
  end 
}


# tvdb = TvdbParty::Search.new("FACBC9B54A326107")
# 
# show_array = Array.new
# genre_array = Array.new
# for i in 400000..600000
  # begin
    # hash_show = Hash.new
    # tvdb_show = tvdb.get_series_by_id(i)
    # if tvdb_show.nil? || tvdb_show.posters('en').nil? || tvdb_show.posters('en').first.nil? || tvdb_show.name.nil? || tvdb_show.overview.nil?
      # next
    # else 
      # puts i
      # puts tvdb_show
    # end
    # hash_show['title'] = tvdb_show.name
    # hash_show['overview'] = tvdb_show.overview
    # hash_show['rating'] = tvdb_show.rating 
    # hash_show['poster'] = tvdb_show.posters('en').first.url
    # show_genres = tvdb_show.genres
#     
    # show_genres.each { |genre| 
      # genre_hash = { :name => genre }
      # unless genre_array.include?(genre_hash)
        # genre_array.push(genre_hash)
      # end 
    # }
#     
    # hash_show['genres'] = show_genres
    # # puts show
    # show_array.push(hash_show)
    # File.open("next200000_2.tv.txt", "a") { |f| 
      # f.puts(hash_show) 
    # }
    # rescue
      # puts 'Exception occurred'
    # end
# end
# 
# #puts genre_array
# puts show_array.size
# File.open("next200000.tv.txt", "a") { |f| 
  # f.print(genre_array)
  # f.puts
  # show_array.each { |x|
    # f.puts(x)
  # }
# }
# 
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
# puts show_array
# 
# movie_titles = ['Argo', 'Perks of being a wallflower', 'Looper', 'Seven Psychopaths', 'The Dark Knight Rises', 'Avatar',
      # 'The Dark Knight', 'Cruel Intentions', 'The Avengers', 'Harry Potter', 'Iron Man', 
      # 'Spiderman', 'Titanic', 'The Texas Chainsaw Massacre', 'I am Legend', 'Lord of the Rings', 'The Mummy']
# movie_array = Array.new
# movie_titles.each { |title| 
  # hash_movie = Hash.new
  # hash_movie['name'] = title
  # rt_movie = Rotten::Movie.find_first title
  # hash_movie['rating'] = rt_movie.ratings['critics_score']
  # hash_movie['user_rating'] = rt_movie.ratings['audience_score']
  # hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
  # hash_movie['description'] = rt_movie.synopsis
  # hash_movie['poster'] = rt_movie.posters['detailed']
  # movie_array.push(hash_movie)
# }
# 
# puts movie_array

