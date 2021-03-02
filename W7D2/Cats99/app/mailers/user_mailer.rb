class UserMailer < ApplicationMailer
  default from: 'noreply@purrhub.com', reply_to: "noreply@purrhub.com"

  def welcome_email(user)
    @user = user
    mail( to: "#{user.username} <#{user.email}>", subject: 'Activate your new Purrhub account' )
  end
end
