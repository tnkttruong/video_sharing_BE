require 'rails_helper'

RSpec.describe 'Videos API', type: :request do
  let(:user) { create(:user, email: 'test@gmail.com') }
  let(:payload) { { sub: user.id, email: user.email } }
  let(:token) { JWT.encode(payload, ENV['JWT_LOGIN_SECRET_KEY'], 'none') }
  before do
    # Create videos for testing
    create_list(:video, 10, user: user) # page 1
    create_list(:video, 5, user: user)  # page 2
  end

  describe 'GET /v1/videos' do
    context 'when an internal server error occurs' do
      it 'returns a 500 error' do
        allow_any_instance_of(V1::VideosController).to receive(:index).and_raise(StandardError)
        get '/v1/videos'

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq('StandardError')
      end
    end

    context 'when requesting page 1' do
      it 'returns a success response with 10 items' do
        get '/v1/videos', params: { page: 1 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body.length).to eq(10)
      end
    end

    context 'when requesting page 2' do
      it 'returns a success response with 5 items' do
        get '/v1/videos', params: { page: 2 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body.length).to eq(5)
      end
    end

    context 'when requesting page 3' do
      it 'returns a success response with 0 items' do
        get '/v1/videos', params: { page: 3 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body.length).to eq(0)
      end
    end
  end

  describe 'GET /v1/videos/:id' do
    context 'when an internal server error occurs' do
      it 'returns a 500 error' do
        allow_any_instance_of(V1::VideosController).to receive(:show).and_raise(StandardError)
        get '/v1/videos/1'

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['error']).to eq('StandardError')
      end
    end

    context 'when the video exists' do
      let(:video) { create(:video, user: user) }

      it 'returns the details of the video' do
        get "/v1/videos/#{video.id}"

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('id', 'title', 'video_id', 'detail', 'user')
        expect(body['id']).to eq(video.id)
        expect(body['title']).to eq(video.title)
        expect(body['video_id']).to eq(video.video_id)
        expect(body['detail']).to eq(video.detail)
        expect(body['user']).to include('email')
        expect(body['user']['email']).to eq(user.email)
      end
    end

    context 'when the video does not exist' do
      it 'returns a not found error' do
        get '/v1/videos/0'

        expect(response).to have_http_status(404)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['code']).to eq(0)
        expect(body['error']).to eq("Couldn't find Video with 'id'=0")
      end
    end
  end

  describe 'POST /v1/videos' do
    context 'when not authenticated' do
      it 'returns a 401 unauthorized error' do
        post '/v1/videos'

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['code']).to eq(0)
      end
    end

    context 'when url param is missing' do
      it 'returns an error for missing url' do
        post '/v1/videos', headers: { 'x-authorization': token }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['code']).to eq(0)
        expect(body['error']).to eq("Url can't be blank")
      end
    end

    context 'when url param is invalid' do
      it 'returns an error for invalid url' do
        post '/v1/videos', headers: { 'x-authorization': token },
                           params: { url: 'https://www.youtube.com/watch?v=' }

        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to include('code', 'error', 'data')
        expect(body['code']).to eq(0)
        expect(body['error']).to eq('Url is invalid')
      end
    end

    context 'when the request is valid' do
      it 'creates a new video' do
        post '/v1/videos', headers: { 'x-authorization': token },
                           params: { url: 'https://www.youtube.com/watch?v=8jPQjjsBbIc' }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        body = JSON.parse(response.body)
        expect(body).to eq(true)
      end
    end
  end
end
