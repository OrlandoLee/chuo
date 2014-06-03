class AddQuantityToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :quantity, :integer
  end
end
