# this will add the 'spudsy default rating' into each movie's record
require 'pp'
require 'rubygems'
Movie.all.each do |movie|
  movie.spudsy_rating = Movie.getRating movie
  movie.save
end