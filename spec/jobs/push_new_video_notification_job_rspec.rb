require 'rails_helper'

RSpec.describe PushNewVideoNotificationJob, type: :job do
  let(:video) { create(:video) }
  let(:users) { create_list(:user, 3) }
  let(:firebase_client) { instance_double(Firebase::Client) }

  before do
    allow(Firebase::Client).to receive(:new).and_return(firebase_client)
    allow(firebase_client).to receive(:set)
    allow(User).to receive(:all).and_return(users)
  end

  it 'does nothing if no video is provided' do
    described_class.perform_now(nil)
    expect(firebase_client).not_to have_received(:set)
  end

  it 'sends a notification to all users if video is provided' do
    described_class.perform_now(video)
    users.each do |user|
      expect(firebase_client).to have_received(:set).with("notifications/#{user.id}", { id: video.id, user_email: video.user.email, title: video.title}).once
    end
  end
end
