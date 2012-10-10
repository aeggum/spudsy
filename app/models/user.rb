class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me#, :admin
  #attr_accessible :email, :password, :password_confirmation, :encrypted_password, :remember_me, :reset_password_token, :reset_password_sent_at, :remember_created_at, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :admin, as: :administrator
  attr_protected :none, as: :administrator
  # attr_accessible :title, :body
  scope :admin_user, where(:admin => true)
  
end
