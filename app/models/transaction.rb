require "bunny"

class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :business 
  delegate :business_meta, to: :business
   
  def self.squash(user_id)
    result = {}
    all_user_record = Transaction.where({user_id:user_id})
    all_user_record.each do |r|
      if r.exchange
        sign = -1
      else
        sign = 1
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
      enqueue(UserMail.exchange_notification_email(User.find(user_id),business_name))
      #UserMail.exchange_notification_email(User.find(user_id),business_name).deliver
      "Success"
    else
      "You may have exchanged"
    end
  end
  
  def self.dequeue_send_email
    # dequeue receive:
    #as a new thread in rails
      conn = Bunny.new
      conn.start
      ch   = conn.create_channel
      q    = ch.queue("email")
      q.subscribe(:block => true) do |delivery_info, properties, body|
        Marshal.load(body).deliver #must use deliver to send email
      end
    end
    
    
    
  private 
  def self.enqueue(email_object)
    conn = Bunny.new
    conn.start
    ch   = conn.create_channel
    q    = ch.queue("email")
    object_enqueued = Marshal.dump(email_object)
    ch.default_exchange.publish(object_enqueued, :routing_key => q.name)
    conn.close
  end
end
