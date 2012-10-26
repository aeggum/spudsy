module APIS
  require 'rubygems'
  require 'httparty'
  
  class RottenTomatoes
    include HTTParty
    base_uri 'http://api.rottentomatoes.com/'
    default_params :apiKey => 'pykjuv5y44fywgpu2m7rt4dk'
      
    
    def self.full_movie_info(id)
      response = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/movies/#{id}.json?apikey=pykjuv5y44fywgpu2m7rt4dk")
      puts response.body #, response.code, response.message, response.headers.inspect
    end
    
    def self.movie_reviews(id, page_limit, page, country)
      response = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/movies/#{id}/reviews.json?review_type=top_critic&page_limit=#{page_limit}&page=#{page}&country=#{country}&apikey=pykjuv5y44fywgpu2m7rt4dk")
      puts response.body
    end
    
    def self.top_rentals(limit, country)
      response = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=#{limit}&country=#{country}&apikey=pykjuv5y44fywgpu2m7rt4dk")
      puts response.body
      puts response.class
      puts response.body.class
      # map = response.body.each_pair do |key, value|
        # if (key == "title") 
          # puts value
        # end
      # end
    end
  end
end
