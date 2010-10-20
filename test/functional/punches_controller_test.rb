require 'test_helper'

class PunchesControllerTest < ActionController::TestCase
  setup do
    @punch = punches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:punches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create punch" do
    assert_difference('Punch.count') do
      post :create, :punch => @punch.attributes
    end

    assert_redirected_to punches_path
  end

  test "should show punch" do
    get :show, :id => @punch.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @punch.to_param
    assert_response :success
  end

  test "should update punch" do
    put :update, :id => @punch.to_param, :punch => @punch.attributes
    assert_redirected_to punches_path
  end

  test "should destroy punch" do
    assert_difference('Punch.count', -1) do
      delete :destroy, :id => @punch.to_param
    end

    assert_redirected_to punches_path
  end
end
