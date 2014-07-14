class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :check_business!
  before_action :check_completed?
  
  # GET /businesses
  # GET /businesses.json
  def index
     if current_user.admin
       @businesses = Business.all
     else
      @businesses = Business.where(business_meta_id: current_user.business_metum.id)
    end
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @qr_code = RQRCode::QRCode.new("http://#{request.host}:#{request.port}/display/new/#{@business.qr_code}",:size => 8, :level => :h)
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json   
  def create
    @business = Business.find_by(business_params) || Business.new(business_params)
      @business.random = Random.rand(100000)
      @business.business_meta_id = current_user.business_metum.id
      respond_to do |format|
        if @business.save
          @business.reload
          @business.qr_code = @business.generate_qrcode_hash
          if @business.save
          format.html { redirect_to @business, notice: 'Business was successfully created.' }
          format.json { render action: 'show', status: :created, location: @business }
          else
            format.html { render action: 'new' }
            format.json { render json: @business.errors, status: :unprocessable_entity }
          end
        else
          format.html { render action: 'new' }
          format.json { render json: @business.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      # @business.random = Random.rand(100000)、#1
      #  if @business.update(business_params.merge({"random" => @business.random,"qr_code" => @business.generate_qrcode_hash}))
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url }
      format.json { head :no_content }
    end
  end
  
  def users

    business_ids = []
    Business.where(business_meta_id: current_user.business_metum.id).each do |business|
      business_ids << business.id
    end      

    all_business_records = Transaction.where(:business_id => business_ids)
    
    @results = {}

    all_business_records.each do |r|
      if r.exchange
        sign = -1
      else
        sign = 1
      end
      user_email = r.user.email
      if @results.has_key?(user_email)
        @results[user_email] += sign*r.amount 
      else
        @results[user_email] = sign*r.amount 
      end
    end
  end
  
  #Get /businesses/exchange/1
  def exchange
    user_id = User.find_by_email(params[:email]+'.'+params[:format]).id
    render text:Transaction.exchange(user_id,current_user.business_metum.id)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
      if current_user.business_metum.id != @business.business_meta_id
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.require(:business).permit(:quantity)
    end
    
    def check_business!
      redirect_to root_path unless current_user.role == 2 || current_user.admin
    end

    def check_completed?
      redirect_to new_business_metum_path unless current_user.business_metum || current_user.admin
    end
end
