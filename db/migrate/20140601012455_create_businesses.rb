class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :qr_code
      t.integer :random
      t.integer :get_one_amount

      t.timestamps
    end
    add_index :businesses, :qr_code
  end
end
