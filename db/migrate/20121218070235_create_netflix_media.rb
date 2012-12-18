class CreateNetflixMedia < ActiveRecord::Migration
  def change
    create_table :netflix_media do |t|
      t.string :name
      t.string :media_type
      t.integer :media_id

      t.timestamps
    end
    
    add_index :netflix_media, :name
    add_index :netflix_media, :media_id, :unique => true
  end
end
