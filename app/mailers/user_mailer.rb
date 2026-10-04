class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: t('.subject')
    )
  end
end
