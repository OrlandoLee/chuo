require 'test_helper'

class BusinessMetaControllerTest < ActionController::TestCase
  setup do
    @business_metum = business_meta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:business_meta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create business_metum" do
    assert_difference('BusinessMetum.count') do
      post :create, business_metum: { location: @business_metum.location, logo: @business_metum.logo, name: @business_metum.name, phone: @business_metum.phone, redeem_number: @business_metum.redeem_number }
    end

    assert_redirected_to business_metum_path(assigns(:business_metum))
  end

  test "should show business_metum" do
    get :show, id: @business_metum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @business_metum
    assert_response :success
  end

  test "should update business_metum" do
    patch :update, id: @business_metum, business_metum: { location: @business_metum.location, logo: @business_metum.logo, name: @business_metum.name, phone: @business_metum.phone, redeem_number: @business_metum.redeem_number }
    assert_redirected_to business_metum_path(assigns(:business_metum))
  end

  test "should destroy business_metum" do
    assert_difference('BusinessMetum.count', -1) do
      delete :destroy, id: @business_metum
    end

    assert_redirected_to business_meta_path
  end
end
