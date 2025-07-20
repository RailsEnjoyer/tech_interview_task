require "test_helper"

class DocsControllerTest < ActionDispatch::IntegrationTest
  test "should get readme" do
    get docs_readme_url
    assert_response :success
  end
end
