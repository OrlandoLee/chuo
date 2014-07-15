class BusinessMetaController < ApplicationController
  before_action :set_business_metum, only: [:show, :edit, :update]
  before_action :check_business!
  
  def check_business!
    redirect_to root_path unless current_user.role == 2 || current_user.admin
  end

  # GET /business_meta
  # GET /business_meta.json
  def index
    if current_user.admin
      @business_meta = BusinessMetum.all
    else
      @business_meta = current_user.business_metum
    end
  end

  # GET /business_meta/1
  # GET /business_meta/1.json
  def show
  end

  # GET /business_meta/new
  def new
    @business_metum = BusinessMetum.new
  end

  # GET /business_meta/1/edit
  def edit
  end

  # POST /business_meta
  # POST /business_meta.json
  def create
    @business_metum = BusinessMetum.find_by(user_id: current_user.id) || BusinessMetum.new(business_metum_params)
    @business_metum.user_id = current_user.id
    respond_to do |format|
      if @business_metum.save
        format.html { redirect_to @business_metum, notice: 'Business metum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @business_metum }
      else
        format.html { render action: 'new' }
        format.json { render json: @business_metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_meta/1
  # PATCH/PUT /business_meta/1.json
  def update
    respond_to do |format|
      if @business_metum.update(business_metum_params)
        format.html { redirect_to @business_metum, notice: 'Business metum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @business_metum.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_metum
      if current_user.admin
        @business_metum = BusinessMetum.find(params[:id])
      else
        @business_metum = BusinessMetum.find(current_user.business_metum.id)
      end
    end
  # Never trust parameters from the scary internet, only allow the white list through.
  def business_metum_params
    params.require(:business_metum).permit(:name, :redeem_number, :location, :phone, :logo)
  end
end
