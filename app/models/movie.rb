class Movie < ActiveRecord::Base
  
  #Validates the follow are present before saving in the database
  validates :rating, :user_rating, :mpaa_rating, :name, :presence => true
  
  attr_accessible :description, :name, :rating, :user_rating, :mpaa_rating, :poster, :release_date, :genre, :runtime, :rt_id, :spudsy_score, :certified, :popularity
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
  has_many :hidden_user_medias, :as => :media
  
  scope :high_rating, where("(rating > 90)")
  scope :high_user_rating, where("(user_rating > 90)")
  scope :low_rating, where("(rating < 35)")
  scope :low_user_rating, where("(user_rating < 35)")
  scope :high_spudsy_score, where("(spudsy_rating) > 85")
  before_save :default_values
  
  
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
  
  # Gets a basic rating for a movie.
  # Looks at rating, user rating, certified, year
  # TODO: will look at certified status, popularity, ?runtime?
  def self.getRating movie
    cFactor = (movie.certified? ? 1.5 : 0.75)
    
    rating = movie.rating * 1.5 * cFactor
    rating += movie.user_rating * 0.5 * cFactor
    
    movie_year = movie.release_date.to_s[0, 4].to_i
    this_year = Time.new.to_s[0,4].to_i
    year_dif = (this_year - movie_year)
    
    # Way of making the year affect the ratings
    # Essentialy a complicated algebraic equation
    yFactor = 1
    case year_dif 
    when -10..10
      yFactor = 1
    when 10..20
      yFactor = getYFactor(0, 0.01, year_dif - 10, 0.1)
    when 20..40
      yFactor = getYFactor(0.1, 0.0075, year_dif - 20, 0.25)
    when 40..90
      yFactor = getYFactor(0.25, 0.015, year_dif - 40, 0.99)
    else 
      yFactor = 0.01
    end
    
    rating *= yFactor
    rating /= 3       # absolute max score is 300
    # puts "Rating for #{movie.name}: #{rating}"
    return rating.round
  end
  
  def ==(another)
    return self.name == another.name && self.spudsy_rating == another.spudsy_rating
  end
  
  def default_values
    self.spudsy_rating = Movie.getRating(self)
  end
  
  private 
    def self.getYFactor(startDrop, dropFactor, years_in_range, max) 
      yFactor = startDrop
      yFactor += dropFactor * (years_in_range)
      yFactor = max if (yFactor > max)
      1 - yFactor
    end
end


# Below is an example of how we will be able to add genres to movies and keep the genre table small
# movie = Movie.first
# movie.genres
# movie.genres.push(Genre.first)
# movie.genres.push(Genre.where{ name >> genre_array_for_movie })
