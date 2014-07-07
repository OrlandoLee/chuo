class BusinessMetum < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, through: :businesses
end
