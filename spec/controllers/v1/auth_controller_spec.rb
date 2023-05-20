require 'rails_helper'

RSpec.describe 'Login API', type: :request do
  describe 'POST /login' do
    context 'when an internal server error occurs' do
      it 'returns a 500 error' do
        allow_any_instance_of(V1::AuthController).to receive(:login).and_raise(StandardError)
        post '/v1/login', params: { email: 'test@gmail.com', password: 'password' }

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq('StandardError')
      end
    end

    context 'Login failed' do
      it 'with blank email and returns an error for blank email' do
        post '/v1/login', params: { email: '', password: "password" }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        
        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq("User can't be blank")
      end

      it 'with blank password and returns an error for blank password' do
        post '/v1/login', params: { email: 'test@example,com', password: "" }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        
        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq("Password can't be blank")
      end

      let!(:user) { create(:user, email: 'test@gmail.com', encrypted_password: BCrypt::Password.create("password")) }

      it 'with incorrect password and returns an error for incorrect password' do
        post '/v1/login', params: { email: 'test@gmail.com', password: 'wrongpassword' }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        
        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq('Password is invalid')
      end
    end

    context 'Login success' do
      let!(:user) { create(:user, email: 'test@gmail.com', encrypted_password: BCrypt::Password.create("password")) }
      it 'with email not existing in the system' do
        post '/v1/login', params: { email: 'nonexisting@gmail.com', password: 'password' }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        
        body = JSON.parse(response.body)
        expect(body).to include('email', 'id', 'auth_token')
        expect(body['email']).to eq('nonexisting@gmail.com')
        expect(body['id']).to eq(User.last.id)
        expect(body['auth_token']).not_to be_nil
      end

      it 'with email existing in the system' do
        post '/v1/login', params: { email: 'test@gmail.com', password: 'password' }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        
        body = JSON.parse(response.body)
        expect(body).to include('email', 'id', 'auth_token')
        expect(body['email']).to eq('test@gmail.com')
        expect(body['id']).to eq(user.id)
        expect(body['auth_token']).not_to be_nil
      end
    end
  end
end
