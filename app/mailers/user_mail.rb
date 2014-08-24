class UserMail < ActionMailer::Base
  default from: "orlando@chuochuo.me"
  
  def exchange_notification_email(user,business_name="")
    @user = user
    @url = 'chuochuo.me'
    @business_name = business_name
    mail(to:@user.email,subject: '戳戳：兑换成功！')
  end
  
  def welcome(user)
    @user = user
    @url = 'chuochuo.me'
    mail(to:@user.email,subject: '账号注册成功，欢迎加入戳戳')
  end
  
  def send_report()
    @users = User.where("created_at >= :start_date",{start_date: Date.today})
    email = 'lizongshenglzs@gmail.com'
    mail(to:email,subject: "#{Time.now} report")
  end
end
