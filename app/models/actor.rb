class Actor < ActiveRecord::Base
  attr_accessible :name
  belongs_to :media, :polymorphic => true
end
