class TvShow < ActiveRecord::Base
  
  #validates that the following are present before saving to the DB
  validates :name, :rating, :presence => true
  
  attr_accessible :description, :name, :rating, :poster, :genres, :tvdb_id, :release_date
  has_many :actors, :as => :media
  has_many :media_genres, :as => :media
  has_many :genres, :as => :media, :through => :media_genres
  
  scope :high_rating, where("(rating > 9.5)")
  scope :low_rating, where("(rating < 3.0)")
  
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
  
end
