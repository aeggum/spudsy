class AddSpudsyRatingToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :spudsy_rating, :float
    add_index :tv_shows, :spudsy_rating
  end
    
end
