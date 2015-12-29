require 'test_helper'

class HasScopesController < ApplicationController
  persists_scopes

  def index
    render nothing: true
  end

  private

  def current_scopes
    fake_scopes
  end

  def fake_scopes
    params.select{ |key, _| key == 'a_scope' } || {}
  end
end

class PersistentScopesTest < ActionController::TestCase
  tests HasScopesController

  def test_saves_scopes
    get :index, a_scope: 123

    assert_response :ok

    get :index

    assert_response :found
    assert_redirected_to(controller: :has_scopes, action: :index, a_scope: 123)
  end

  def test_ignores_another_arguments
    get :index, not_a_scope: 123

    assert_response :ok

    get :index

    assert_response :ok
  end
end
