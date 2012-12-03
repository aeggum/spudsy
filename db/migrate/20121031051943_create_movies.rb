class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.float :rating
      t.text :description
      t.date :release_date
      t.float :user_rating
      t.string :mpaa_rating
      t.string :poster
      t.integer :runtime
      t.string :rt_id
      t.float :spudsy_rating

      t.timestamps
    end
    
    add_index :movies, :name
  end
end