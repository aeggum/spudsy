ActiveAdmin.register TvShow do  
  config.per_page = 10
  config.sort_order = "id_asc"
  scope "Loved", :high_rating
  scope "Hated", :low_rating
  scope "Spudsy > 8", :high_spudsy_rating
  

  index do
    column :id
    column :name
    column "tvdb user rating", :rating
    column :spudsy_rating
    column 'Genres' do |tv_show|
      tv_show.genres.collect(&:name).join(", ")
    end
    column :release_date
    column "View" do |tv_show|
      link_to "View", admin_tv_show_path(tv_show)
    end
    column "Delete" do |tv_show|
      link_to "Delete", admin_tv_show_path(tv_show), :method => :delete
    end
  end
  
  # new or edit form for a user becomes this
  form do |f|
  end
  
  filter :name
  filter :id
  filter :rating
  filter :spudsy_rating
end
