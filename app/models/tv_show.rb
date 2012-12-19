class TvShow < ActiveRecord::Base
  
  #validates that the following are present before saving to the DB
  validates :name, :rating, :presence => true
  
  attr_accessible :description, :name, :rating, :poster, :genres, :tvdb_id, :release_date, :spudsy_ratings, :imdb_id, :runtime, :mpaa
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
  has_many :hidden_user_medias, :as => :media
  
  
  scope :high_rating, where("(rating > 9.5)")
  scope :low_rating, where("(rating < 3.0)")
  scope :high_spudsy_rating, where("(spudsy_rating) > 0.8")
  before_save :default_values
  
  include PgSearch
  pg_search_scope :search, against: [:name],
      using: {tsearch: {dictionary: "english", any_word: "true"}}
      
  multisearchable :against => [:name]
      #using: {tsearch: {dictionary: "english", any_word: "true"}},
      #ignoring: :accents,
      #:using =>:dmetaphone
      
  def self.text_search(query)
    if query.present?
      search(query)
      
    else
      scoped
    end
  end
  
  def ==(another)
    return self.name == another.name && self.rating == another.rating && self.description == another.description
  end
  
  # def to_s
    # puts "name: #{self.name}"
  # end
  
  # TODO: Get a rating for each tvshow
  def self.getRating tv_show
    if (tv_show.rating == 0 || tv_show.rating.nil?)
      return 10
    end
    cFactor = (tv_show.rating > 7.5)? 1.5 : 0.7
    
    rating = tv_show.rating * 1.5 * cFactor
    yFactor = getYFactor(tv_show.release_date.to_s[0..3])
    rating *= yFactor 
    rating /= 22.5  
    if rating > 1.0
      rating = 1.0
    end
    rating *= 100.0
    return rating.round
  end
  
  # TODO: Need to add spudsy_rating to TvShow 
  def default_values
    self.spudsy_rating = TvShow.getRating(self)
  end
  
  private 
    def self.getYFactor(release_year)
      current = Time.now.to_s[0..3].to_i
      release_year = release_year.to_i
      diff = current - release_year
      
      # TODO: Make years matter less
      yFactor = 1
      case diff
      when -10..14
        yFactor = 1.0
      when 14..25
        yFactor = yFactorEq(1.0, 0.95, diff, 0.005)
      when 25..45
        yFactor = yFactorEq(0.95, 0.85, diff, 0.10/20.0)
      when 45..65 
        yFactor = yFactorEq(0.85, 0.75, diff, 0.10/20.0)
      else 
        yFactor = 0.50
      end
      
      return yFactor
    end
    
    # algebraic equation for yFactor
    def self.yFactorEq(max, min, diff, x)
      yFactor = max
      yFactor -= (x * diff)
      yFactor = min if (yFactor < min)
      return yFactor
    end
  
end
