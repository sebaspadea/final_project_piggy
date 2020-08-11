class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = User.find(params[:user_id])
    mail(to: @user.email, subject: 'Bienvenido a Piggy')
  end

  def weekly_email
    @user = User.find(params[:user_id])
    mail(to: @user.email, subject: 'Resumen de tu cuentas')
  end
end

