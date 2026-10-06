class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      PasswordResetMailer.with(user: user).reset.deliver_now
    end
    redirect_to login_path, success: t(".success")
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:token])
    unless @user
      redirect_to new_password_reset_path, danger: t(".failure")
    end
  end

  def update
    @user = User.find_by_token_for(:password_reset, params[:token])
    unless @user
      redirect_to new_password_reset_path, danger: t(".failure")
      return
    end
    if @user.update(password_params)
      redirect_to login_path, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.expect(user: [ :password, :password_confirmation ])
  end
end
