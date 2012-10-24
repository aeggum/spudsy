ActiveAdmin.register User do
  config.per_page = 20      # pagination after 20
  scope "Admin Users", :admin_user    # 'admin users' button
  index do
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    default_actions
  end
  
  # new or edit form for a user becomes this
  form do |f| 
    f.inputs 'User' do
      f.input :email
      f.input :password
      f.input :password_confirmation
      
    end
    f.inputs 'Admin?' do
      f.input :admin
    end
    f.buttons
  end
  
  filter :email
  filter :sign_in_count, :label => "Sign in count"
end
