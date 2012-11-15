class MediaGenre < ActiveRecord::Base
  attr_accessible :genre_id, :media_id, :media_type, :genre
  
  belongs_to :media, :polymorphic => true
  belongs_to :genre
end
