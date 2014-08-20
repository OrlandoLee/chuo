class Users::RegistrationsController < Devise::RegistrationsController
 
  before_filter :configure_permitted_parameters

  def new_business
    new
  end
  
  def new
    @signin_page = true
    super
  end
  
  def create
    super
    Transaction.enqueue(::UserMail.welcome(@user)) unless @user.invalid?
    # ::UserMail.welcome(@user).deliver unless @user.invalid?
  end
  
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:role,:email, :password, :password_confirmation)
    end
  end
 
end