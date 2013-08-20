require 'test_helper'

class FeeditemsControllerTest < ActionController::TestCase
  setup do
    @feeditem = feeditems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeditems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feeditem" do
    assert_difference('Feeditem.count') do
      post :create, feeditem: {  }
    end

    assert_redirected_to feeditem_path(assigns(:feeditem))
  end

  test "should show feeditem" do
    get :show, id: @feeditem
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feeditem
    assert_response :success
  end

  test "should update feeditem" do
    put :update, id: @feeditem, feeditem: {  }
    assert_redirected_to feeditem_path(assigns(:feeditem))
  end

  test "should destroy feeditem" do
    assert_difference('Feeditem.count', -1) do
      delete :destroy, id: @feeditem
    end

    assert_redirected_to feeditems_path
  end
end
