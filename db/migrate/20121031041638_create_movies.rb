class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.float :rating
      t.text :description
      t.date :release_date
      t.references :actor

      t.timestamps
    end
    add_index :movies, :actor_id
  end
end
