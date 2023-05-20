require 'rails_helper'

RSpec.describe V1::Auth::LoginOperation, type: :operation do
  let(:user) { create(:user, email: 'test@example.com', encrypted_password: BCrypt::Password.create("password")) }
  let(:params) { { email: 'test@example.com', password: 'password' } }
  let(:operation) { V1::Auth::LoginOperation.new(params) }

  describe '#call' do
    context 'when email is blank' do
      let(:params) { { email: '', password: 'password' } }

      it 'raises an UnprocessableEntity error' do
        expect { operation.call }.to raise_error(ExceptionError::UnprocessableEntity)
      end
    end

    context 'when password is blank' do
      let(:params) { { email: 'test@example.com', password: '' } }

      it 'raises an UnprocessableEntity error' do
        expect { operation.call }.to raise_error(ExceptionError::UnprocessableEntity)
      end
    end

    context 'when user does not exist' do
      before do
        allow(User).to receive(:find_or_initialize_by).and_return(User.new)
      end

      it 'calls set_encrypted_password and save on user' do
        expect_any_instance_of(User).to receive(:set_encrypted_password).with('password')
        expect_any_instance_of(User).to receive(:save)
        operation.call
      end

      it 'sets auth_token on user' do
        operation.call
        expect(operation.user.auth_token).to be_present
      end
    end

    context 'when user exists' do
      before do
        allow(User).to receive(:find_or_initialize_by).and_return(user)
      end

      it 'does not call set_encrypted_password and save on user' do
        expect(user).not_to receive(:set_encrypted_password)
        expect(user).not_to receive(:save)
        operation.call
      end

      it 'sets auth_token on user' do
        operation.call
        expect(operation.user.auth_token).to be_present
      end
    end
  end
end
