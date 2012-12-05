require 'action_view'
gem 'httparty', '0.7.8'
require 'tvdb_party'
require 'pp'
include ActionView::Helpers::DateHelper
tvdb = TvdbParty::Search.new("FACBC9B54A326107")


# TODO: needs to be tested in current form
###############################################################################
# Writes tv information to a file, coming from queries to tvdb
###############################################################################
show_array = Array.new
genre_array = Array.new
start_index = 400000     # starting index for tvdb search
end_index = 450000    # ending index for tvdb search

for i in start_index..end_index
  begin
    hash_show = Hash.new
    tvdb_show = tvdb.get_series_by_id(i)
    if tvdb_show.nil? || tvdb_show.posters('en').nil? || tvdb_show.posters('en').first.nil? || tvdb_show.name.nil? || tvdb_show.overview.nil? || tvdb_show.rating == 0.0
      next
    else
      puts tvdb_show
    end
    hash_show['title'] = tvdb_show.name
    hash_show['tvdb_id'] = tvdb_show.id
    hash_show['rating'] = tvdb_show.rating
    hash_show['overview'] = tvdb_show.overview 
    hash_show['poster'] = tvdb_show.posters('en').first.url
    hash_show['release_date'] = tvdb_show.first_aired.strftime("%Y-%m-%d")
    show_genres = tvdb_show.genres
    
    # show_genres.each { |genre| 
      # genre_hash = { :name => genre }
      # unless genre_array.include?(genre_hash)
        # genre_array.push(genre_hash)
      # end 
    # }
    
    hash_show['genres'] = show_genres
    # puts show
    show_array.push(hash_show)
    File.open("#{start_index}..#{end_index}.tv.txt", "a") { |f| 
      f.puts(hash_show) 
    }
    rescue
      print '.'  # exception
    end
end

# put the genre array to the end of the file
# File.open("#{start_index}..#{end_index}.tv.txt", "a") { |f| 
  # f.puts(genre_array)
  # f.puts
  # show_array.each { |x|
    # f.puts(x)
  # }
# }
