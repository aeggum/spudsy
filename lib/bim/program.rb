class Program < Station
  # Essentially a whitelist of all variables for the class
  attr_accessor :id, :title, :episode_title, :description, :language, :start_utc, :duration, :hd, :new, :ei, :year, :original_air_date, :tv_rating, :mpaa_rating, :star_rating, :genres, :cast_members
  
  def initialize(options = {})
    options.each { |key, value| 
      instance_variable_set("@#{key}", value)   
    }
  end
  
  def to_s
    str = "\nid: #{@id}, title: #{@title}, episode_title: #{@episode_title}, description: #{@description}, language: #{@language}, start: #{start_utc}, duration: #{@duration}, hd: #{@hd}, "
    str += "new: #{@new}, ei: #{@ei}, year: #{@year}, original_air_date: #{@original_air_date}, tv_rating: #{@tv_rating}, mpaa_rating: #{@mpaa_rating}, stars: #{@star_rating}, "
    str += "genres: #{@genres}, cast: #{@cast}"
    return str;
  end
 
end