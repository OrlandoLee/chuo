class BusinessController < ApplicationController
  def new
    @business = Business.first
    render text: @business.generate_qrcode_hash
  end
end
