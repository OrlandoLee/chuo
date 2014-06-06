class AddNameIdex < ActiveRecord::Migration
  def change
    add_index :businesses, :name
  end
end
