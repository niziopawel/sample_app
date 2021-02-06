# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  before_action :set_user, only: %i[edit]
  def edit
    if valid_user_and_token?
      handle_successful_activation
    else
      handle_failed_activation
    end
  end

  private

  def valid_user_and_token?
    @user && !@user.activated? && @user.valid_token?(:activation, params[:id])
  end

  def handle_successful_activation
    @user.activate_user
    log_in @user
    flash[:success] = 'Account activated'
    redirect_to @user
  end

  def handle_failed_activation
    flash[:danger] = 'Invalid activation link'
    redirect_to root_url
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end
end
