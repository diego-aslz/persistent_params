require 'test_helper'

class MyController < ApplicationController
  persists_params

  def index
    render nothing: true
  end
end

class TestPersistentParams < ActionController::TestCase
  tests MyController

  def test_redirects_to_last_used_params
    get :index, something: 123

    assert_response :ok

    get :index

    assert_response :found
    assert_redirected_to(controller: :my, action: :index, something: 123)
  end

  def test_does_not_redirect_empty_params
    get :index

    assert_response :ok

    get :index

    assert_response :ok
  end

  def test_clears_params
    get :index, something: 123

    assert_response :ok

    get :index, clear: true

    assert_response :ok

    get :index

    assert_response :ok
  end
end
