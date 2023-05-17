module ExceptionError
  BAD_REQUEST           = { status: 400, code: 'bad request' }.freeze
  UNAUTHORIZED          = { status: 401, code: 'unauthorized' }.freeze
  FORBIDDEN             = { status: 403, code: 'forbidden' }.freeze
  NOT_FOUND             = { status: 404, code: 'not found' }.freeze
  CONFLICT              = { status: 409, code: 'conflict' }.freeze
  UNPROCESSABLE_ENTITY  = { status: 422, code: 'unprocessable_entity' }.freeze
  INTERNAL_SERVER_ERROR = { status: 500, code: 'Server busy. Please try again' }.freeze
  NOT_IMPLEMENTED       = { status: 501, code: 'not implemented' }.freeze
  SERVICE_UNAVAILABLE   = { status: 503, code: 'service unavailable' }.freeze

  def status_code_according_to(exception)
    case exception
    when ExceptionError::BadRequest, ExceptionError::ResourceInvalid, ActionController::BadRequest
      ExceptionError::BAD_REQUEST
    when ExceptionError::Unauthorized, SecurityError
      ExceptionError::UNAUTHORIZED
    when ExceptionError::Forbidden, ActionController::InvalidAuthenticityToken
      ExceptionError::FORBIDDEN
    when ActiveRecord::RecordNotFound, ActionController::RoutingError, ExceptionError::NotFound
      ExceptionError::NOT_FOUND
    when ActiveRecord::RecordNotUnique
      ExceptionError::CONFLICT
    when ExceptionError::UnprocessableEntity
      ExceptionError::UNPROCESSABLE_ENTITY
    else
      ExceptionError::INTERNAL_SERVER_ERROR
    end
  end

  class Application < StandardError; end
  class BadRequest < Application; end
  class ResourceInvalid < Application; end
  class Unauthorized < Application; end
  class Forbidden < Application; end
  class NotFound < Application; end
  class ResourceNotFound < Application; end
  class Conflict < Application; end
  class UnprocessableEntity < Application; end
  class InternalServerError < Application; end
end
