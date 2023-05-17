class ApplicationController < ActionController::API
  include Renderable
  include Errorable

  def authenticate_user!
    raise ExceptionError::Unauthorized, '' if current_user.blank?
  end

  def current_user
  end
end
