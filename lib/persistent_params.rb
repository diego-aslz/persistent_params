require 'ostruct'

module PersistentParams
  module ClassMethods
    def persistent_params_config
      @persistent_params_config ||= OpenStruct.new
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
    params.except(*ignored_params)
  end

  def ignored_params
    Array(persistent_params_config.ignored_params)
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
    @last_params_key ||= self.class.name.underscore.to_sym
  end
end

class ActionController::Base
  def self.persists_params(ignore: %w(controller action))
    include PersistentParams
    persistent_params_config.ignored_params = ignore
  end
end
