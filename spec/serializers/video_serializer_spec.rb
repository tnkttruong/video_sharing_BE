require 'rails_helper'

RSpec.describe VideoSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }
  let(:serializer) { VideoSerializer.new(video) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'includes the expected attributes' do
    expect(subject['id']).to eq(video.id)
    expect(subject['title']).to eq(video.title)
    expect(subject['video_id']).to eq(video.video_id)
    expect(subject['detail']).to eq(video.detail)
  end

  it 'includes the associated user attributes' do
    expect(subject['user']).to have_key('email')
    expect(subject['user']['email']).to eq(user.email)
  end
end
