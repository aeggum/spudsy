class CreateNetflixMedia < ActiveRecord::Migration
  def change
    create_table :netflix_media do |t|
      t.string :name
      t.string :media_type
      t.integer :media_id
      t.integer :spudsy_rating

      t.timestamps
    end
    
    add_index :netflix_media, :name
    add_index :netflix_media, :spudsy_rating
    add_index :netflix_media, ["name", "media_id", "media_type"], :unique => true
  end
end
