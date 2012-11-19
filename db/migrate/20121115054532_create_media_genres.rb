class CreateMediaGenres < ActiveRecord::Migration
  def change
    create_table :media_genres do |t|
      t.string :media_type
      t.integer :media_id
      t.integer :genre_id

      t.timestamps
    end
    add_index :media_genres, :media_id
    add_index :media_genres, :media_type
  end
end
