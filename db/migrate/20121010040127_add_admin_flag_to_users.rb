class AddAdminFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :bool
    add_column :users, :zip, :integer
  end
end
