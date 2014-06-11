class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :business 
  def self.squash(user_id)
    result = {}
    all_user_record = Transaction.where({user_id:user_id})
    sign = 1
    all_user_record.each do |r|
      if r.exchange
        sign = -1
      end
      business_name = r.business.name
      if result.has_key?(business_name)
        result[business_name] += sign*r.amount 
      else
        result[business_name] = sign*r.amount 
      end
    end
    result
  end
  
  def self.allow_exchange?(user_amount,business_name)
    business_get_one_amount = Business.find_by_name(business_name).get_one_amount
    if !user_amount.nil? && !business_get_one_amount.nil? && business_get_one_amount<= user_amount
      true
    else
      false
    end
  end

  def self.exchange(business_name,user_id)
    result = Transaction.squash(user_id)
    user_amount = result[business_name]
    
    if Transaction.allow_exchange?(user_amount,business_name)
      business = Business.find_by_name(business_name)
      Transaction.create(user_id: user_id, business_id: business.id, exchange: true, amount: business.get_one_amount)
      #send email
      render text:"Succeed"
    else
      render text:"You may have exchanged"
    end
  end
end
