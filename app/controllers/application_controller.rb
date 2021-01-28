# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  def current_user
    # if current_user exists, User.find_by won't be executed
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  helper_method :logged_in?, :current_user
end
