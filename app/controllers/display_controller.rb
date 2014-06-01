class DisplayController < ApplicationController
  before_action :authenticate_user!
  def index
  end
  
  def new
    begin
      regulated_time_range = 1
      qr_code = params[:id]
      business = Business.find_by qr_code: qr_code
      scanned = Transaction.exists?(user_id: current_user.id, business_id: business.id,:created_at => regulated_time_range.hour.ago..Time.now)
      if scanned
        render text: "You have already scanned the code."
      else  
        Transaction.create(user_id: current_user.id, business_id: business.id) #default is one
      end
    rescue
      render text:"please scan the code again"
    end
    #render text: params[:id]
  end
end
