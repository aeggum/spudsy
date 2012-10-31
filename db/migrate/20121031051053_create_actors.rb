class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :name
      t.integer :media_id
      t.string :media_type

      t.timestamps
    end
  end
end
