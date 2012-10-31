class Actor < ActiveRecord::Base
  attr_accessible :media_id, :media_type, :name
  belongs_to :media, :polymorphic => true
end
