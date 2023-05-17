module Errorable
  extend ActiveSupport::Concern
  include Renderable

  unless Rails.env.development? && true
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
        # do something when have error at here!!
        resource_error = ResourceError.new(e)
        Rails.logger.error e
        render_error resource_error.to_message, resource_error.status
      end
    end
  end
end
