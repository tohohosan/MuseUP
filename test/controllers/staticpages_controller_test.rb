require "test_helper"

class StaticpagesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_path
    assert_response :success
  end
end
