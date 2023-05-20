# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#password_valid?' do
    let(:user) { create(:user) } # this will create a user using the factory we defined

    context 'when the password is valid' do
      it 'returns true' do
        expect(user.password_valid?('password')).to be true
      end
    end

    context 'when the password is invalid' do
      it 'returns false' do
        expect(user.password_valid?('wrong_password')).to be false
      end
    end
  end
end
