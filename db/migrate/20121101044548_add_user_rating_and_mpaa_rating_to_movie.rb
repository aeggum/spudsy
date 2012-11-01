class AddUserRatingAndMpaaRatingToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :user_rating, :float
    add_column :movies, :mpaa_rating, :string
  end
end
