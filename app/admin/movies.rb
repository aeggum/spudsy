ActiveAdmin.register Movie do
  config.per_page = 10
  config.sort_order = "id_asc"
  scope "Critically acclaimed", :high_rating
  scope "Popular", :high_user_rating
  scope "Critically disapproved", :low_rating
  scope "Hated", :low_user_rating
  scope "Spudsy > 85", :high_spudsy_score

  index do
    column :id
    column :name
    column "RT rating", :rating
    column "RT user rating", :user_rating
    column "Our rating", :spudsy_rating
    column 'Genres' do |movie|
      movie.genres.collect(&:name).join(", ")
    end
    column :release_date
    column "View" do |movie|
      link_to "View", admin_movie_path(movie)
    end
    column "Delete" do |movie|
      link_to "Delete", admin_movie_path(movie), :method => :delete
    end
  end
  
  # new or edit form for a user becomes this
  form do |f|
  end
  
  filter :name
  filter :id
  filter :rt_id, :label => "RT ID"
  filter :rating
  filter :user_rating
  filter :spudsy_rating
end
