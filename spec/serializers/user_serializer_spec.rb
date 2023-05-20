require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serializer) { UserSerializer.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'includes the expected attributes' do
    expect(subject['email']).to eq(user.email)
  end
end
