# spec/models/video_spec.rb

require 'rails_helper'

RSpec.describe Video, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let!(:video1) { create(:video, user: user, created_at: 1.hour.ago) }
    let!(:video2) { create(:video, user: user, created_at: 2.hours.ago) }

    it "orders by newest first" do
      expect(Video.newest).to eq([video1, video2])
    end
  end
end
