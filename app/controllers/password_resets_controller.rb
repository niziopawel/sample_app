# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[create edit update]
  before_action :valid_user_and_token, only: %i[edit update]
  before_action :check_token_expiration, only: %i[edit update]

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = "User with the given email address doesn't exit"
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update(reset_digest: nil)
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user_and_token
    unless @user&.activated? && @user&.valid_token?(:reset, params[:id])
      redirect_to root_url
      flash[:danger] = 'Invalid email address or reset token'
    end
  end

  def check_token_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset has expired'
      redirect_to new_password_reset_path
    end
  end
end
