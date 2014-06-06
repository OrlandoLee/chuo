class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :business 
  def self.squash(user_id)
    result = {}
    all_user_record = Transaction.where({user_id:user_id})
    all_user_record.each do |r|
      business_name = r.business.name
      if result.has_key?(business_name)
        result[business_name] += r.amount 
      else
        result[business_name] = r.amount 
      end
    end
    result
  end
end
