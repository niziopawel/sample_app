# frozen_string_literal: true

require 'test_helper'
require 'integration/integration_test_helper'

class UsersSignupTest < IntegrationTestHelper
  def setup
    ActionMailer::Base.deliveries.clear
  end
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'Example User',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activation
    log_in_as(user)
    assert_not logged_in?

    # invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?

    # valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong@email')
    assert_not logged_in?

    # valid token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end
