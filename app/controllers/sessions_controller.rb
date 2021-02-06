# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    # find user with given eamil
    @user = User.find_by(email: params[:session][:email].downcase)
    # authenticate user with given password if user exist
    if @user&.authenticate(params[:session][:password])
      @user.activated? ? successful_login : handle_login_with_not_activated_account
    else
      failed_login
    end
  end

  def destroy
    if logged_in?
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
    redirect_to root_path
  end

  private

  def successful_login
    # log the user in and redireccto to the user's show page.
    log_in @user
    manage_remember_me_cookies(params[:session][:remember_me], @user)
    redirect_back_or @user
  end

  def failed_login
    flash.now[:danger] = 'Invalid email or password'
    render 'new'
  end

  def handle_login_with_not_activated_account
    message = 'Account not activated. '
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end
end
