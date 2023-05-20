require 'rails_helper'

RSpec.describe V1::Auth::LoginForm, type: :model do
  let(:user) { create(:user) }
  let(:password) { 'password' }
  let(:form) { described_class.new(user: user, password: password) }

  describe 'validations' do
    context 'when user is present' do
      it 'is valid' do
        expect(form).to be_valid
      end

      context 'when password is valid' do
        it 'is valid' do
          expect(user).to receive(:password_valid?).with(password).and_return(true)
          expect(form).to be_valid
        end
      end

      context 'when password is not valid' do
        it 'is not valid' do
          expect(user).to receive(:password_valid?).with(password).and_return(false)
          expect(form).to be_invalid
          expect(form.errors[:password]).to include("is invalid")
        end
      end
    end

    context 'when user is not present' do
      let(:user) { nil }

      it 'is not valid' do
        expect(form).to be_invalid
        expect(form.errors.messages[:user]).to include('can\'t be blank')
      end
    end

    context 'when password is not present' do
      let(:password) { nil }

      it 'is not valid' do
        expect(form).to be_invalid
        expect(form.errors.messages[:password]).to include('can\'t be blank')
      end
    end
  end
end
