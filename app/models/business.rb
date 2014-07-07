require 'digest/sha1'

class Business < ActiveRecord::Base
  has_many :transactions
  has_many :users, through: :transactions
  belongs_to :business_meta
  def generate_qrcode_hash
    Digest::SHA1.hexdigest "#{business_meta_id}-#{random}-#{quantity}-#{created_at}"        
  end
  
end