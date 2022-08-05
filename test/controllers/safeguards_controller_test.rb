require "test_helper"

class SafeguardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @safeguard = safeguards(:one)
  end

  test "should get index" do
    get safeguards_url, as: :json
    assert_response :success
  end

  test "should create safeguard" do
    assert_difference("Safeguard.count") do
      post safeguards_url, params: { safeguard: { description: @safeguard.description, hazard_id: @safeguard.hazard_id } }, as: :json
    end

    assert_response :created
  end

  test "should show safeguard" do
    get safeguard_url(@safeguard), as: :json
    assert_response :success
  end

  test "should update safeguard" do
    patch safeguard_url(@safeguard), params: { safeguard: { description: @safeguard.description, hazard_id: @safeguard.hazard_id } }, as: :json
    assert_response :success
  end

  test "should destroy safeguard" do
    assert_difference("Safeguard.count", -1) do
      delete safeguard_url(@safeguard), as: :json
    end

    assert_response :no_content
  end
end
