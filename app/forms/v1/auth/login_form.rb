class V1::Auth::LoginForm < ApplicationForm
  attribute :user
  attribute :password

  validates :user, presence: true
	validates :password, presence: true
  with_options if: :exists_user? do
    validate :check_password_valid
  end

  private
  def check_password_valid
    errors.add(:password, :invalid) unless user.password_valid?(password)
  end

  def exists_user?
  	user&.id
  end
end
