class TvShow < ActiveRecord::Base
  
  #validates that the following are present before saving to the DB
  validates :name, :rating, :presence => true
  
  attr_accessible :description, :name, :rating, :poster, :genres, :tvdb_id, :release_date
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
  has_many :hidden_user_medias, :as => :media
  
  
  scope :high_rating, where("(rating > 9.5)")
  scope :low_rating, where("(rating < 3.0)")
  #before_save :default_values
  
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
  
  # TODO: Get a rating for each tvshow
  def self.getRating tv_show
    cFactor = (tv_show.rating > 7.5)? 1.5 : 0.7
    
    rating = tv_show.rating * 1.5 * cFactor
    yFactor = getYFactor(tv_show.release_date.to_s[0..3])
    rating *= yFactor 
    rating /= 33.75  # absolute max score
  end
  
  # TODO: Need to add spudsy_rating to TvShow 
  def default_values
    self.spudsy_rating = TvShow.getRating(self)
  end
  
  private 
    def getYFactor(release_year)
      current = Time.now.to_s[0..3].to_i
      release_year = release_year.to_i
      diff = current - release_year
      
      yFactor = 1
      case diff
      when -10..3
        yFactor = 1.5
      when 3..7
        yFactor = 1.2
      when 7..11
        yFactor = 1.0
      when 11..20
        yFactor = yFactorEq(1.0, 0.75, diff, 0.025)
      when 20..40
        yFactor = yFactorEq(0.75, 0.50, diff, 0.0125)
      when 40..60 
        yFactor = yFactorEq(0.50, 0.20, diff, 0.015)
      else 
        yFactor = 0.10
      end
      
      return yFactor
    end
    
    def yFactorEq(max, min, diff, x)
      yFactor = max
      yFactor -= (x * diff)
      yFactor = min if (yFactor < min)
      return yFactor
    end
  
end
