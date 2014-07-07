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
      business_meta_id = r.business.business_meta_id
      if result.has_key?(business_meta_id)
        result[business_meta_id] += sign*r.amount 
      else
        result[business_meta_id] = sign*r.amount 
      end
    end
    result
  end
  
  def self.allow_exchange?(user_amount,business_meta_id)
    business_redeem_number = BusinessMetum.find(business_meta_id).redeem_number
    if !user_amount.nil? && !business_redeem_number.nil? && business_redeem_number<= user_amount
      true
    else
      false
    end
  end

  def self.exchange(user_id,business_meta_id)
    result = Transaction.squash(user_id)
    user_amount = result[business_meta_id]
    
    if Transaction.allow_exchange?(user_amount,business_meta_id)
      Transaction.create(user_id: user_id, business_id: Business.find_by_business_meta_id(business_meta_id).id, exchange: true, amount: BusinessMetum.find(business_meta_id).redeem_number)
      #send email
      enqueue(UserMail.exchange_notification_email(User.find(user_id), BusinessMetum.find(business_meta_id).name))
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
