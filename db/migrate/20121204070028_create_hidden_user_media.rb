class CreateHiddenUserMedia < ActiveRecord::Migration
  def change
    create_table :hidden_user_media do |t|
      t.integer :user_id
      t.integer :media_id
      t.string :media_type
      t.boolean :liked

      t.timestamps
    end
    
    add_index :hidden_user_media, :user_id
  end
end
