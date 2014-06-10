class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_admin!
  
  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
  
  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.all
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @qr_code = RQRCode::QRCode.new("#{request.host}:#{request.port}/display/new/#{@business.qr_code}",:size => 8, :level => :h)
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
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.require(:business).permit(:name, :quantity)
    end
end
