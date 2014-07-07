class CreateBusinessMeta < ActiveRecord::Migration
  def change
    create_table :business_meta do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.integer :redeem_number, null: false
      t.string :location
      t.string :phone
      t.string :logo
      t.boolean :checked

      t.timestamps
    end
  end
end
