ActiveAdmin.register User do
  scope "Admin Users", :admin_user
  index do
    column :email
    column :sign_in_count
    #column :current_sign_in_at
    column :last_sign_in_at
    #column :current_sign_in_ip
    column :last_sign_in_ip
    column :created_at
    column :admin
    default_actions
  end
end
