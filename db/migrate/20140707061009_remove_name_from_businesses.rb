class RemoveNameFromBusinesses < ActiveRecord::Migration
  def change
    remove_column :businesses, :name, :string
  end
end
