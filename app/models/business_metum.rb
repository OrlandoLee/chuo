class BusinessMetum < ActiveRecord::Base
  validates :name, presence: true
  validates :redeem_number, presence: true
  belongs_to :user
  has_many :transactions, through: :businesses
end
