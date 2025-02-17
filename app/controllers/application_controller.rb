# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  helper_method :logged_in?, :current_user, :current_user?

  def current_user
    # if current_user exists, User.find_by won't be executed
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.valid_token?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user?(user)
    user && user == current_user
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end
end
