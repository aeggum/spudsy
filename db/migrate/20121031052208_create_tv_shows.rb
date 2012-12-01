class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :name
      t.string :tvdb_id
      t.float :rating
      t.text :description
      t.string :poster
      t.date :release_date

      t.timestamps
    end
    
    add_index :tv_shows, :name
  end
end
