require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require "../rotten.rb"
require "tmdb"
require 'pp'
include ActionView::Helpers::DateHelper

# TODO: needs to be tested in current form
###############################################################################
# Writes movie information to a file, coming from queries to tmdb and rt apis
###############################################################################

Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
Tmdb::Tmdb.default_language = "en"
movieArray = Array.new
movieTitles = Array.new

start_index = 0     # the id from tmdb where you start the search
end_index = 1000    # the id from tmdb where you end the search

(start_index..end_index).each { |i| 
  movie_array = Array.new
  titles = Array.new
  overviews = Array.new
  genres = Array.new
  begin 
    movie = Tmdb::TmdbMovie.find(:id => i)
    if (movie.nil? || movie.empty?)
      next
    end
    titles.push(movie.original_title)
    overviews.push(movie.overview)
    
    # genre array gets one index for each movie
    unless movie.genres.nil?
      genre_arr = Array.new
      movie.genres.each { |genre| 
        genre_hash = { :name => genre.name }
        # unless genre_array.include?(genre_hash)
          # genre_array.push(genre_hash)
        # end 
        genre_arr.push(genre_hash)
      }
      genres.push(genre_arr)
    end
    
    titles.each_with_index { |title, index|
      hash_movie = Hash.new
      hash_movie['name'] = title
      rt_movie = Rotten::Movie.find_first title
      if rt_movie.nil?
        next
      end
      hash_movie['rating'] = rt_movie.ratings['critics_score']
      hash_movie['user_rating'] = rt_movie.ratings['audience_score']
      hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
      # if the RT synopsis is empty, use the tmdb one
      if (rt_movie.synopsis.nil? || rt_movie.synopsis.empty?)
        hash_movie['description'] = overviews[index]
      else
        hash_movie['description'] = rt_movie.synopsis
      end
      hash_movie['poster'] = rt_movie.posters['detailed']
      hash_movie['release_date'] = rt_movie.release_dates['theater']
      hash_movie['rt_id'] = rt_movie.id
      hash_movie['runtime'] = rt_movie.runtime
      hash_movie['genres'] = genres[index]
      movie_array.push(hash_movie)
      File.open("test.movie.#{start_index}.#{end_index}.txt", "a") { |f| 
        f.puts(hash_movie) 
      }
    }
    
    
  rescue
    # caught exception
    print '.'
  end 
}