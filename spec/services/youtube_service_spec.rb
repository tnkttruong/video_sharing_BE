require 'rails_helper'

RSpec.describe YoutubeService do
  describe '#fetch_video_detail' do
    let(:url) { 'https://www.youtube.com/watch?v=test_video_id' }
    let(:youtube_service) { YoutubeService.new(url) }

    let(:youtube) { instance_double(Google::Apis::YoutubeV3::YouTubeService) }
    let(:response) { instance_double(Google::Apis::YoutubeV3::ListVideosResponse) }
    let(:item) { instance_double(Google::Apis::YoutubeV3::Video) }
    let(:snippet) { instance_double(Google::Apis::YoutubeV3::VideoSnippet) }

    before do
      allow(Google::Apis::YoutubeV3::YouTubeService).to receive(:new).and_return(youtube)
      allow(youtube).to receive(:key=)
      allow(youtube).to receive(:list_videos).and_return(response)

      allow(response).to receive(:items).and_return([item])
      allow(item).to receive(:snippet).and_return(snippet)
      allow(snippet).to receive(:title).and_return('Test Video')
      allow(snippet).to receive(:description).and_return('This is a test video.')
    end

    it 'fetches video details' do
      video_details = youtube_service.fetch_video_detail
      expect(video_details[:title]).to eq('Test Video')
      expect(video_details[:detail]).to eq('This is a test video.')
      expect(video_details[:id]).to eq('test_video_id')
    end

    context 'when an error occurs' do
      before do
        allow(youtube).to receive(:list_videos).and_raise(StandardError)
      end

      it 'returns an empty hash and logs the error' do
        expect(Rails.logger).to receive(:error).exactly(6).times
        expect(youtube_service.fetch_video_detail).to eq({})
      end
    end
  end
end

