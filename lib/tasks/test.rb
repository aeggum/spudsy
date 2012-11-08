require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require "../rotten.rb"
include ActionView::Helpers::DateHelper

Rotten.api_key = 'pykjuv5y44fywgpu2m7rt4dk'
movieArray = Array.new

# TODO: Generate the seeds file with the top movies, or whatever.
# TODO: We'll want to do something similar to below, but put into seeds.rb

file1 = File.open("test2.rb", "r+")
  
if file1
  content = file1.sysread(10)
  puts content
else 
  puts "Unable to open file!"
end

# A pair of sample data that we would want to put into the seeds file
movieArray.push( 
  {:name => "foo", :rating => 100.0, :user_rating => 10.0, :description => "the first part of foobar", :mpaa_rating => "R", :release_date => DateTime.strptime("09/20/2010 8:00", "%m/%d/%Y %H:%M")}, 
  {:name => "bar", :user_rating => 200.0, :mpaa_rating => "PG-13", :description => "the other part of foobar", :rating => 99.0, :release_date => DateTime.strptime("09/20/2010 8:00", "%m/%d/%Y %H:%M")} 
)
puts movieArray

# tvdb = TvdbParty::Search.new("FACBC9B54A326107")
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

movie_titles = ['Argo', 'Perks of being a wallflower', 'Looper', 'Seven Psychopaths', 'The Dark Knight Rises', 'Avatar',
      'The Dark Knight', 'Cruel Intentions', 'The Avengers', 'Harry Potter', 'Iron Man', 
      'Spiderman', 'Titanic', 'The Texas Chainsaw Massacre', 'I am Legend', 'Lord of the Rings', 'The Mummy']
movie_array = Array.new
movie_titles.each { |title| 
  hash_movie = Hash.new
  hash_movie['name'] = title
  rt_movie = Rotten::Movie.find_first title
  hash_movie['rating'] = rt_movie.ratings['critics_score']
  hash_movie['user_rating'] = rt_movie.ratings['audience_score']
  hash_movie['mpaa_rating'] = rt_movie.mpaa_rating
  hash_movie['description'] = rt_movie.synopsis
  hash_movie['poster'] = rt_movie.posters['detailed']
  movie_array.push(hash_movie)
}

puts movie_array
puts 'foo'

