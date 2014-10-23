require 'test_helper'

class PoemesControllerTest < ActionController::TestCase
  setup do
    @poeme = poemes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:poemes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create poeme" do
    assert_difference('Poeme.count') do
      post :create, poeme: { auteur_id: @poeme.auteur_id, content: @poeme.content, recueil: @poeme.recueil, slug: @poeme.slug, title: @poeme.title, written_date: @poeme.written_date }
    end

    assert_redirected_to poeme_path(assigns(:poeme))
  end

  test "should show poeme" do
    get :show, id: @poeme
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @poeme
    assert_response :success
  end

  test "should update poeme" do
    patch :update, id: @poeme, poeme: { auteur_id: @poeme.auteur_id, content: @poeme.content, recueil: @poeme.recueil, slug: @poeme.slug, title: @poeme.title, written_date: @poeme.written_date }
    assert_redirected_to poeme_path(assigns(:poeme))
  end

  test "should destroy poeme" do
    assert_difference('Poeme.count', -1) do
      delete :destroy, id: @poeme
    end

    assert_redirected_to poemes_path
  end
end
