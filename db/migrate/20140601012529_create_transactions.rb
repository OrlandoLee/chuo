class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :business_id
      t.boolean :exchange, default:false
      t.integer :amount, default:1

      t.timestamps
    end
    add_index :transactions, :user_id
    add_index :transactions, :business_id
  end
end
