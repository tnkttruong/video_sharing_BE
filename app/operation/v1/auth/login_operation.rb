class V1::Auth::LoginOperation < ApplicationOperation
  attr_accessor :user
  def call
    find_user
    validation!
    save_user
    login
  end

  private

  def find_user
    @user = User.find_or_initialize_by(email: params[:email]) if params[:email].present?
  end

  def validation!
    @form = V1::Auth::LoginForm.new(user: user, password: params[:password])
    form.valid!
  end

  def save_user
    return if @form.user.id
    @user.set_encrypted_password(form.password)
    @user.save
  end

  def login
    @user.auth_token = get_token
  end

  def get_token
    payload = {
      sub: user.id,
      email: user.email
    };
    JWT.encode(payload, ENV['JWT_LOGIN_SECRET_KEY'], 'none')
  end
end
