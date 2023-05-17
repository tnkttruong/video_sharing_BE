require 'bcrypt'
class User < ApplicationRecord
  attr_accessor :auth_token

  def password_valid?(password)
    BCrypt::Password.new(self.encrypted_password) == password rescue false
  end

  def set_encrypted_password(password)
    self.encrypted_password = BCrypt::Password.create(password)
  end
end
