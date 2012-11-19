class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :name
      t.float :rating
      t.text :description
      t.string :poster

      t.timestamps
    end
    
    add_index :tv_shows, :name
  end
end
