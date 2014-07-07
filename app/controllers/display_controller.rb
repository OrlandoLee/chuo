class DisplayController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to businesses_path if current_user.role == 2
    @record = Transaction.squash(current_user.id)
  end
  
  def new
    begin
      regulated_time_range = 0
      qr_code = params[:id]
      business = Business.find_by qr_code: qr_code #returns only one
      scanned = Transaction.exists?(user_id: current_user.id, business_id: business.id,:created_at => regulated_time_range.hour.ago..Time.now)
      if scanned
        render text: "You have already scanned the code."
      else  
        Transaction.create(user_id: current_user.id, business_id: business.id, amount: business.quantity)
        #@record = Transaction.squash(current_user.id)
      end
    rescue
      render text:"please scan the code again"
    end
    #render text: params[:id]
  end
  
  def geonew
     t = Transaction.where(user_id:current_user.id).order('created_at desc').first
     t.latitude = params[:latitude]
     t.longitude = params[:longitude]
     t.save!
     
     @record = Transaction.squash(current_user.id)
     #render text:'stuff'
  end
  
  def exchange
    user_id = current_user.id
    name = params[:name]
    render text:Transaction.exchange(name,user_id)
  end

end
