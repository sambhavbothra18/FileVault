require "test_helper"

class PublicFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_files_show_url
    assert_response :success
  end
end
