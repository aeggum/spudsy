class AddPhotoUrlToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :photo_url, :string
  end
end
