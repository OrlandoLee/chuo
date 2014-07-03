class AddLatitudeLongitudeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :latitude, :string
    add_column :transactions, :longitude, :string
  end
end
