class ResourceError
  include ExceptionError

  attr_reader :status, :message

  def initialize(exception)
    status_code = status_code_according_to(exception)
    @status     = status_code[:status]
    @code       = status_code[:code]
    @message    = exception.message
  end

  private

  attr_reader :code
end
