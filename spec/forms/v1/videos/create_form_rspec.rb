require 'rails_helper'

RSpec.describe V1::Videos::CreateForm, type: :model do
  let(:valid_url) { 'https://www.youtube.com/watch?v=Test1234' }
  let(:invalid_url) { 'https://invalid.url' }

  let(:valid_youtube_data) do
    {
      title: 'Test Video',
      detail: 'This is a test video.',
      id: 'Test1234'
    }
  end

  before do
    allow_any_instance_of(YoutubeService).to receive(:fetch_video_detail).and_return(valid_youtube_data)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      form = V1::Videos::CreateForm.new(url: valid_url)
      expect(form.valid?).to be true
    end

    it 'is invalid without a url' do
      form = V1::Videos::CreateForm.new(url: nil)
      expect(form.valid?).to be false
      expect(form.errors[:url]).to include("can't be blank")
    end

    it 'is invalid with an incorrect url' do
      allow_any_instance_of(YoutubeService).to receive(:fetch_video_detail).and_return({})
      form = V1::Videos::CreateForm.new(url: invalid_url)
      expect(form.valid?).to be false
      expect(form.errors[:url]).to include("is invalid")
    end
  end
end
