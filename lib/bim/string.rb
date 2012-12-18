
class String
  def self.class_to_data_id(clazz)
    if (clazz == "Movie")
      return "movies"
    else 
      return "tv_shows"
    end
  end
end