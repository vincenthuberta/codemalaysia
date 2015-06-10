require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user) #make sure the user is logged in first
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "foo@invalid",
                                    password:   "foo",
                                    password_confirmation: "bar"}
    assert_template 'users/edit' #comes back to the edit page again
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user) #make sure the user is logged in first
    if session[:forwarding_url] != nil
      assert_redirected_to session[:forwarding_url]
    else
      assert_redirected_to edit_user_path(@user)
    end
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password:   "",
                                    password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
  end
end
