require "test_helper"

class NavbarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get navbar_index_url
    assert_response :success
  end
end
