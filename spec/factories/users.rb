FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "testuser#{n}@test.com"
    end
    encrypted_password { BCrypt::Password.create("password") }
  end
end