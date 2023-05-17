module Errorable
  extend ActiveSupport::Concern
  include Renderable

  included do
    rescue_from StandardError do |e|
      handle(e)
    end

    rescue_from ExceptionError::Application do |e|
      handle(e)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      handle(e)
    end

    def handle(e)
      resource_error = ResourceError.new(e)
      Rails.logger.error(e.class.name)
      Rails.logger.error("  type: #{e.class.name}")
      Rails.logger.error("  message: #{e.message}")
      Rails.logger.error("  backtrace:")
      Rails.logger.error("    " + e.backtrace.join("\n    "))
      render_error resource_error.message, resource_error.status
    end
  end
end
