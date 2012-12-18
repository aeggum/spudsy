class NetflixMedia < ActiveRecord::Base
  attr_accessible :media_id, :media_type, :name, :spudsy_rating
  before_save :default_values
  
  # Gets the media id for each netflix type before it is saved
  def default_values
    id = -1
    spudsy_rating = -1
    if (self.media_type == "Movie")
      m = Movie.where [ 'name = ? ', self.name ]
      begin
        id = m[0].id
        spudsy_rating = m[0].spudsy_rating
      rescue
        id = -1
      end
    elsif (self.media_type == "TvShow")
      t = TvShow.where [ 'name = ? ', self.name ]
      begin
        id = t[0].id
        spudsy_rating = t[0].spudsy_rating
      rescue
        id = -1
      end
    end
    self.media_id = id
    self.spudsy_rating = spudsy_rating
  end
end
