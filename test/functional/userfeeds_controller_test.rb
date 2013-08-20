require 'test_helper'

class UserfeedsControllerTest < ActionController::TestCase
  setup do
    @userfeed = userfeeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:userfeeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create userfeed" do
    assert_difference('Userfeed.count') do
      post :create, userfeed: {  }
    end

    assert_redirected_to userfeed_path(assigns(:userfeed))
  end

  test "should show userfeed" do
    get :show, id: @userfeed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @userfeed
    assert_response :success
  end

  test "should update userfeed" do
    put :update, id: @userfeed, userfeed: {  }
    assert_redirected_to userfeed_path(assigns(:userfeed))
  end

  test "should destroy userfeed" do
    assert_difference('Userfeed.count', -1) do
      delete :destroy, id: @userfeed
    end

    assert_redirected_to userfeeds_path
  end
end
