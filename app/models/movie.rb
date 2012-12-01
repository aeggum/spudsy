class Movie < ActiveRecord::Base
  
  #Validates the follow are present before saving in the database
  validates :rating, :user_rating, :mpaa_rating, :name, :presence => true
  
  attr_accessible :description, :name, :rating, :user_rating, :mpaa_rating, :poster, :release_date, :genre, :runtime, :rt_id
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
  
  scope :high_rating, where("(rating > 90)")
  scope :high_user_rating, where("(user_rating > 90)")
  scope :low_rating, where("(rating < 35)")
  scope :low_user_rating, where("(user_rating < 35)")
  
  include PgSearch
  pg_search_scope :search, against: [:name],
      using: {tsearch: {dictionary: "english", any_word: "true"}, dmetaphone: {}},
      ignoring: :accents

  multisearchable :against => [:name]
      #using: {tsearch: {dictionary: "english", any_word: "true"}, dmetaphone: {}},
      #ignoring: :accents

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
  
end


# Below is an example of how we will be able to add genres to movies and keep the genre table small
# movie = Movie.first
# movie.genres
# movie.genres.push(Genre.first)
# movie.genres.push(Genre.where{ name >> genre_array_for_movie })
