class DisplayController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to businesses_path if current_user.role == 2
    get_display_data
  end
  
  def new
    begin
      regulated_time_range = 1
      qr_code = params[:id]
      business = Business.find_by qr_code: qr_code
      business_meta = BusinessMetum.find(business.business_meta_id)
      
      if business_meta.one_time_code?
        regulated_time_range = 0
      end
      scanned = Transaction.exists?(user_id: current_user.id, business_id: business.id,:created_at => regulated_time_range.hour.ago..Time.now)
      if scanned
        render text: "You have already scanned the code."
      else  
        Transaction.create(user_id: current_user.id, business_id: business.id, amount: business.quantity)
        
        if business_meta.one_time_code?
          business.random = Random.rand(100000)
          business.update({"random" => business.random,"qr_code" => business.generate_qrcode_hash})
          #qr_code = RQRCode::QRCode.new("http://#{request.host}:#{request.port}/display/new/#{business.qr_code}",:size => 8, :level => :h)
          Pusher["#{business.id}"].trigger('my_event', {
              # host: request.host,
              # port: request.port,
              # qr_code: business.qr_code,
              # size: 8,
              # level: 'h'
              # qr_code: qr_code
              id: business.id
            })
        end
        
        @record = Transaction.squash(current_user.id)
      end
    rescue
          render text:"the code you scanned is invalid, please refreash"
    end
    #render text: params[:id]
  end
  
  def geonew
     t = Transaction.where(user_id:current_user.id).order('created_at desc').first
     t.latitude = params[:latitude]
     t.longitude = params[:longitude]
     t.save!
     
     get_display_data
     render 'display/index'
  end
  
  def exchange
    user_id = current_user.id
    meta_id = params[:meta_id]
    render text:Transaction.exchange(user_id,meta_id)
  end

  private
  
  def get_display_data 
    @record = Transaction.squash(current_user.id)
    @business_metum  = {}
    @record.each do |r|
       @business_metum[r[0]] = BusinessMetum.find(r[0]) 
    end
  end
end
