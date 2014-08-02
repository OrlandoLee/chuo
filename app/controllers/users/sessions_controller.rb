class Users::SessionsController < Devise::SessionsController
 
  def new
    @signin_page = true
    super
  end 
end