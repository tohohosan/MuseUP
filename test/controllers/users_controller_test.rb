require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one) # 必要に応じて適切なテストユーザーをセットアップ
    sign_in @user       # ログイン処理を追加
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "should get update" do
    patch update_user_path(@user), params: { user: { name: "Updated Name" } }
    assert_response :redirect
  end
end
