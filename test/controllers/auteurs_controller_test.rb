require 'test_helper'

class AuteursControllerTest < ActionController::TestCase
  setup do
    @auteur = auteurs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auteurs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auteur" do
    assert_difference('Auteur.count') do
      post :create, auteur: { birth_date: @auteur.birth_date, century: @auteur.century, country: @auteur.country, death_date: @auteur.death_date, description: @auteur.description, description_source: @auteur.description_source, first_letter: @auteur.first_letter, name: @auteur.name, poemes_count: @auteur.poemes_count, slug: @auteur.slug }
    end

    assert_redirected_to auteur_path(assigns(:auteur))
  end

  test "should show auteur" do
    get :show, id: @auteur
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @auteur
    assert_response :success
  end

  test "should update auteur" do
    patch :update, id: @auteur, auteur: { birth_date: @auteur.birth_date, century: @auteur.century, country: @auteur.country, death_date: @auteur.death_date, description: @auteur.description, description_source: @auteur.description_source, first_letter: @auteur.first_letter, name: @auteur.name, poemes_count: @auteur.poemes_count, slug: @auteur.slug }
    assert_redirected_to auteur_path(assigns(:auteur))
  end

  test "should destroy auteur" do
    assert_difference('Auteur.count', -1) do
      delete :destroy, id: @auteur
    end

    assert_redirected_to auteurs_path
  end
end
