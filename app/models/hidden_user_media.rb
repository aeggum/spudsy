class HiddenUserMedia < ActiveRecord::Base
  validates :media_id, :media_type, :user_id, :presence => true
  attr_accessible :liked, :media_id, :media_type, :user_id
  belongs_to :media, :polymorphic => true
  belongs_to :user
end

# Below: an example of adding to the hidden media for a specific user
# u.hidden_user_medias.push(HiddenUserMedia.new(:user_id => u.id, :media_id => m.id, :media_type => m.class.to_s)