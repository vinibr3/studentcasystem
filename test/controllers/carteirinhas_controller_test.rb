require 'test_helper'

class CarteirinhasControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get autenticacao" do
    get :autenticacao
    assert_response :success
  end

end
