class ApplicationController < ActionController::API
  include Renderable
  include Errorable

  def authenticate_user!
    raise ExceptionError::Unauthorized, '' if current_user.blank?
  end

  def current_user
  	return @current_user if @current_user.present?
    return if request.headers['x-authorization'].blank?
    payload = JWT.decode(request.headers['x-authorization'], ENV['JWT_LOGIN_SECRET_KEY'], false) rescue {}
    return if payload.blank?
    @current_user = User.find_by(email: payload[0]["email"], id: payload[0]["sub"])
  end
end
