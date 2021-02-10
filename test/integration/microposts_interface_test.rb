require 'test_helper'
require 'integration/integration_test_helper'
class MicropostsInterfaceTest < IntegrationTestHelper
  def setup
    @user = users(:michael)
    log_in_as(@user)
    get root_path
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # Correct pagination link
    # Valid submission
    content = 'This micropost really ties the room together'
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg,image/png,image/giv')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert @user.microposts.first.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match '0 microposts', response.body
    other_user.microposts.create!(content: 'First micropost')
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end
end
