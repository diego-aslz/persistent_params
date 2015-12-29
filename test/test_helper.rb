require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'minitest/autorun'

# Configure Rails
ENV['RAILS_ENV'] = 'test'

require 'action_controller'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'persistent_params'

PersistentParams::Routes = ActionDispatch::Routing::RouteSet.new
PersistentParams::Routes.draw do
  get '/:controller(/:action(/:id))'
end

class ApplicationController < ActionController::Base
  include PersistentParams::Routes.url_helpers
end

class ActiveSupport::TestCase
  self.test_order = :random if respond_to?(:test_order=)

  setup do
    @routes = PersistentParams::Routes
  end
end
