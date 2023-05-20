require 'rails_helper'

RSpec.describe UserLoginSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serializer) { UserLoginSerializer.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'includes the expected attributes' do
    expect(subject['id']).to eq(user.id)
    expect(subject['auth_token']).to eq(user.auth_token)
  end
end
