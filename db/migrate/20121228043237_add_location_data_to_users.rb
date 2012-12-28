class AddLocationDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :string
    add_column :users, :default_provider, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float  
  end
end
