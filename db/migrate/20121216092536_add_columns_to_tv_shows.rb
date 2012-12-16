class AddColumnsToTvShows < ActiveRecord::Migration
  def change
    add_column :tv_shows, :imdb_id, :string
    add_column :tv_shows, :runtime, :string
    add_column :tv_shows, :mpaa, :string
  end
end
