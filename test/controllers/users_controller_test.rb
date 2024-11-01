require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_path(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "should get update" do
    get user_path(@user), params: { user: { name: "Updated Name" } }
    assert_response :success
  end
end
