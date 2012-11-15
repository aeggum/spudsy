require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require "../rotten.rb"
require "tmdb"
require 'pp'
include ActionView::Helpers::DateHelper

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

# (1..65).each { |i| 
  # result = Tmdb::TmdbMovie.top_rated(:page => i) 
  # # puts result[0].results
  # #puts result[0].results.class
  # #puts result[0].results[0].original_title
#   
  # movies = result[0].results
#   
  # movies.each { |movie|
    # movieTitles.push(movie.original_title)
  # }
#   
# }

# puts movieTitles

# movie_array = Array.new
# movieTitles.each { |title| 
  # hash_movie = Hash.new
  # hash_movie['name'] = title
  # rt_movie = Rotten::Movie.find_first title
  # if rt_movie.nil?
    # next
  # end
  # hash_movie['rating'] = rt_movie.ratings['critics_score']
  # hash_movie['user_rating'] = rt_movie.ratings['audience_score']
  # hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
  # hash_movie['description'] = rt_movie.synopsis
  # hash_movie['poster'] = rt_movie.posters['detailed']
  # hash_movie['release_date'] = rt_movie.release_dates['theater']
  # movie_array.push(hash_movie)
# }


# puts movie_array

# File.open("test2.rb", "w") { |f| f.write(movie_array) }

#puts "All Done."

tvdb = TvdbParty::Search.new("FACBC9B54A326107")

show_array = Array.new
for i in 75000..75050
  puts i
  hash_show = Hash.new
  tvdb_show = tvdb.get_series_by_id(i)
  if tvdb_show.nil? || tvdb_show.posters('en').nil? || tvdb_show.posters('en').first.nil?
    next
  end
  hash_show['overview'] = tvdb_show.overview
  hash_show['title'] = tvdb_show.name
  hash_show['rating'] = tvdb_show.rating 
  hash_show['poster'] = tvdb_show.posters('en').first.nil?
  # puts show
  show_array.push(hash_show)
end

puts show_array.size
puts "feck"
File.open("test2.rb", "w") { |f| 
  show_array.each { |x|
    f.puts(x)
  }
}
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

