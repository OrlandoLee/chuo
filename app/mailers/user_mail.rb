class UserMail < ActionMailer::Base
  default from: "orlando@chuochuo.me"
  
  def exchange_notification_email(user,business_name="")
    @user = user
    @url = 'chuochuo.me'
    @business_name = business_name
    mail(to:@user.email,subject: 'You have successfully exchanged')
  end
end
