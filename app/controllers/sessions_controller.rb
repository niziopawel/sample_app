# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    # find user with given eamil
    @user = User.find_by(email: params[:session][:email].downcase)

    # authenticate user with given password if user exist
    if @user&.authenticate(params[:session][:password])
      # log the user in and redireccto to the user's show page.
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
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
end
