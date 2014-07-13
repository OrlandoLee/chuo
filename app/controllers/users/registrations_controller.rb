class Users::RegistrationsController < Devise::RegistrationsController
 
  before_filter :configure_permitted_parameters

  def new_business
    new
  end
  
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:role,:email, :password, :password_confirmation)
    end
  end
 
end