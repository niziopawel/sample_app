# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  def current_user
    # if current_user exists, User.find_by won't be executed
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  helper_method :logged_in?, :current_user
end
