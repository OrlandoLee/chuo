class AddOneTimeCodeToBusinessMetum < ActiveRecord::Migration
  def change
    add_column :business_meta, :one_time_code, :boolean, default: true
  end
end
