require 'test_helper'
require 'integration/integration_test_helper'

class PasswordResetsTest < IntegrationTestHelper
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'invalid email' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { email: '' }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test 'valid email, sent email with password reset informations' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, params: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'password resets' do
    # Password reset form
    post password_resets_path, params: { email: @user.email }
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    assert_not flash.empty?
    # Inactive user
    user.update(activated: false)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    user.update(activated: true)
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email, user: { password: '',
                                               password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email, user: { password: 'foobaz',
                                               password_confirmation: 'foobaz' } }
    assert logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
