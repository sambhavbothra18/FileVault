require "test_helper"

class UploadedFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get uploaded_files_index_url
    assert_response :success
  end

  test "should get show" do
    get uploaded_files_show_url
    assert_response :success
  end

  test "should get new" do
    get uploaded_files_new_url
    assert_response :success
  end

  test "should get create" do
    get uploaded_files_create_url
    assert_response :success
  end

  test "should get edit" do
    get uploaded_files_edit_url
    assert_response :success
  end

  test "should get update" do
    get uploaded_files_update_url
    assert_response :success
  end

  test "should get destroy" do
    get uploaded_files_destroy_url
    assert_response :success
  end
end
