class AddBusinessMetaIdToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :business_meta_id, :integer
  end
end
