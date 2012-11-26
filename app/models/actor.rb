class Actor < ActiveRecord::Base
  attr_accessible :name
  belongs_to :media, :polymorphic => true
  
  include PgSearch
  pg_search_scope :search, against: [:name],
      using: {tsearch: {dictionary: "english", any_word: "true"} }
      
  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
  
end
