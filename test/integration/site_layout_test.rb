# frozen_string_literal: true

require 'test_helper'
require 'integration/integration_test_helper'

class SiteLayoutTest < IntegrationTestHelper
  def setup
    @user = users(:michael)
  end
  # test for the presence of a particular link
  # Here rails automatially inserts the value of about_path in place of the question mark
  # w widoku pod url root_path, maja znajdowac sie nastepujace linki
  test 'layout links when logout' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    get contact_path
    assert_select 'title', full_title('Contact')
    get signup_path
    assert_select 'title', full_title('Sign up')
  end

  test 'layout link when log in' do
    log_in_as(@user)
    follow_redirect!
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', '/logout'
  end
end
