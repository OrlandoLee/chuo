class RemoveGetOneAmountFromBusinesses < ActiveRecord::Migration
  def change
    remove_column :businesses, :get_one_amount, :integer
  end
end
