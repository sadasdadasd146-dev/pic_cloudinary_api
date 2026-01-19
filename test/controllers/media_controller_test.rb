require "test_helper"

class MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medium = media(:one)
  end

  test "should get index" do
    get media_url, as: :json
    assert_response :success
  end

  test "should create medium" do
    assert_difference("Medium.count") do
      post media_url, params: { medium: { media_type: @medium.media_type, url: @medium.url, user_id: @medium.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show medium" do
    get medium_url(@medium), as: :json
    assert_response :success
  end

  test "should update medium" do
    patch medium_url(@medium), params: { medium: { media_type: @medium.media_type, url: @medium.url, user_id: @medium.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy medium" do
    assert_difference("Medium.count", -1) do
      delete medium_url(@medium), as: :json
    end

    assert_response :no_content
  end
end
