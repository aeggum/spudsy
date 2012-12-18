class NetflixMedia < ActiveRecord::Base
  attr_accessible :media_id, :media_type, :name
  before_save :default_values
  
  # Gets the media id for each netflix type before it is saved
  def default_values
    id = -1
    puts self.name
    puts self.media_type
    if (self.media_type == "Movie")
      id = Movie.where { name == self.name }[0].id
    elsif (self.media_type == "TvShow")
      puts self.name
      puts self.name.class
      t = TvShow.where [ 'name = ? ', self.name ] #TvShow.where {{ name => self.name }}[0]
      id = t[0].id
    end
    self.media_id = id
  end
end
