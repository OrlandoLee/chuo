require 'digest/sha1'

class Business < ActiveRecord::Base
  has_many :transactions
  has_many :users, through: :transactions
  
  def generate_qrcode_hash
    Digest::SHA1.hexdigest "#{name}-#{random}-#{quantity}-#{created_at}"        
  end
end
