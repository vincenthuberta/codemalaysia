require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user       = users(:michael)
    @other_user = users(:archer) #take the sample data from users.yml
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do #making sure no user is deleted
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:               @other_user.password,
                                            password_confirmation:  @other_user.password_confirmation,
                                            admin:                  true }
                                            #verify that even if the admin status changes, still can't become admin.
    assert_not @other_user.reload.admin? #reload is required after update
  end
  
  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end
  
  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
