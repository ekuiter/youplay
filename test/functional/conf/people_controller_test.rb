require 'test_helper'

class Conf::PeopleControllerTest < ActionController::TestCase
  setup do
    @conf_person = conf_people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conf_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conf_person" do
    assert_difference('Conf::Person.count') do
      post :create, conf_person: {  }
    end

    assert_redirected_to conf_person_path(assigns(:conf_person))
  end

  test "should show conf_person" do
    get :show, id: @conf_person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conf_person
    assert_response :success
  end

  test "should update conf_person" do
    put :update, id: @conf_person, conf_person: {  }
    assert_redirected_to conf_person_path(assigns(:conf_person))
  end

  test "should destroy conf_person" do
    assert_difference('Conf::Person.count', -1) do
      delete :destroy, id: @conf_person
    end

    assert_redirected_to conf_people_path
  end
end
