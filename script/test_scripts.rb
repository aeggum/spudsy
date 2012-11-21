require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require "../lib/rotten.rb"
require "../lib/test_movie.rb"
require "tmdb"
require 'pp'
include ActionView::Helpers::DateHelper

Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
Tmdb::Tmdb.api_key = "8da8a86a8b272a70d20c08a35b576d50"
Tmdb::Tmdb.default_language = "en"
TestMovie.api_key='pykjuv5y44fywgpu2m7rt4dk'
movieArray = Array.new
movieTitles = Array.new
movieOverviews = Array.new
movieGenres = Array.new
# genre_array = Array.new


(1..67).each { |i| 
  result = Tmdb::TmdbMovie.top_rated(:page => i) 
  #puts result[0].results
  #puts result[0].results.class
  #puts result[0].results[0].original_title
  
  movies = result[0].results
  
  movies.each { |movie|
    movie = Tmdb::TmdbMovie.find(:title => movie.original_title, :limit => 1)
    movieTitles.push(movie.original_title)
    movieOverviews.push(movie.overview)
    movie_genres = movie.genres
   
    # movieGenres.push(Test.genre_to_array(movie.genres))
    unless movie_genres.nil?
      genres = Array.new
      movie_genres.each { |genre| 
        genre_hash = { :name => genre.name }
        # unless genre_array.include?(genre_hash)
          # genre_array.push(genre_hash)
        # end 
        genres.push(genre_hash)
      }
      movieGenres.push(genres)
    end
  }
  
}



# puts movieOverviews
# puts movieTitles.size
# puts genre_array


movie_array = Array.new
movieTitles.each_with_index { |title, index| 
  hash_movie = Hash.new
  hash_movie['name'] = title
  rt_movie = Rotten::Movie.find_first title
  if rt_movie.nil?
    next
  end
  hash_movie['rating'] = rt_movie.ratings['critics_score']
  hash_movie['user_rating'] = rt_movie.ratings['audience_score']
  hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
  if (rt_movie.synopsis.nil? || rt_movie.synopsis.empty?)
    hash_movie['description'] = movieOverviews[index]
  else
    hash_movie['description'] = rt_movie.synopsis
  end
  hash_movie['poster'] = rt_movie.posters['detailed']
  hash_movie['release_date'] = rt_movie.release_dates['theater']
  hash_movie['rt_id'] = rt_movie.id
  hash_movie['runtime'] = rt_movie.runtime
  hash_movie['genres'] = movieGenres[index]
  movie_array.push(hash_movie)
}


# puts movie_array

File.open("first_20_pages.movie.txt", "w") { |f| 
  # f.puts(genre_array) 
  f.puts(movie_array) 
}

puts "All Done."

def grab_tv_shows(start_index, end_index)
  tvdb = TvdbParty::Search.new("FACBC9B54A326107")
  
  show_array = Array.new
  genre_array = Array.new
  for i in start_index..end_index
    begin
      hash_show = Hash.new
      tvdb_show = tvdb.get_series_by_id(i)
      if tvdb_show.nil? || tvdb_show.posters('en').nil? || tvdb_show.posters('en').first.nil? || tvdb_show.name.nil? || tvdb_show.overview.nil?
        next
      else 
        puts i
        puts tvdb_show
      end
      hash_show['title'] = tvdb_show.name
      hash_show['overview'] = tvdb_show.overview
      hash_show['rating'] = tvdb_show.rating 
      hash_show['poster'] = tvdb_show.posters('en').first.url
      show_genres = tvdb_show.genres
      
      show_genres.each { |genre| 
        genre_hash = { :name => genre }
        unless genre_array.include?(genre_hash)
          genre_array.push(genre_hash)
        end 
      }
      
      hash_show['genres'] = show_genres
      # puts show
      show_array.push(hash_show)
      File.open("#{start_index}_to_#{end_index}.tv.txt", "a") { |f| 
        f.puts(hash_show) 
      }
      rescue
        puts 'Exception happened'
      end
  end
end

#puts genre_array
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

