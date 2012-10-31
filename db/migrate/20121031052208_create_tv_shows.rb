class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :name
      t.float :rating
      t.text :description

      t.timestamps
    end
  end
end
