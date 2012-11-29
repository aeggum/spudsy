class AddFuzzystrmatchExtension < ActiveRecord::Migration
  def up
    execute "create extension fuzzystrmatch"
  end

  def down   
    execute "drop extension fuzzystrmatch"
  end
end
