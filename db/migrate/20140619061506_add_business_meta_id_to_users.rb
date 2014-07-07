class AddBusinessMetaIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :business_meta_id, :integer
  end
end
