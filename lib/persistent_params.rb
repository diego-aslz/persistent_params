require 'ostruct'

module PersistentParams
  module ClassMethods
    def persistent_params_config(hash = {})
      @persistent_params_config ||= OpenStruct.new(hash)
    end
  end

  def self.included(controller)
    controller.before_filter :check_last_params
    controller.extend ClassMethods
  end

  private

  def check_last_params
    if params[:clear].present?
      self.last_params = nil
      return
    end
    if current_params.empty?
      if last_params.any?
        redirect_to **last_params.symbolize_keys
      end
      return
    end
    self.last_params = current_params
  end

  def current_params
    send(params_method).except(*ignored_keys)
  end

  def params_method
    persistent_params_config.params_method || :params
  end

  def ignored_keys
    %w(controller action)
  end

  def persistent_params_config
    self.class.persistent_params_config
  end

  def last_params
    session[last_params_key] || {}
  end

  def last_params=(scopes)
    session[last_params_key] = scopes
  end

  def last_params_key
    "#{params[:controller]}__#{params[:action]}"
  end
end

class ActionController::Base
  def self.persists_params(**options)
    include PersistentParams
    persistent_params_config(options)
    yield persistent_params_config if block_given?
  end
end
