require 'rails_helper'

RSpec.describe V1::Videos::IndexOperation, type: :operation do
  let(:page) { 1 }
  let(:operation) { V1::Videos::IndexOperation.new(page: page) }

  describe '#call' do
    context 'when videos exist' do
      let!(:videos) { create_list(:video, 15) }

      context 'when requesting page 1' do
        it 'gets videos with expected attributes' do
          expected_videos = videos[0..9].map { |video| instance_double('Video', user: video.user) }

          expect(Video).to receive(:includes).with(:user).and_return(Video)
          expect(Video).to receive(:newest).and_return(Video)
          expect(Video).to receive(:offset).with(0).and_return(Video)
          expect(Video).to receive(:limit).with(10).and_return(expected_videos)

          operation.call

          expect(operation.videos).to eq(expected_videos)
        end
      end

      context 'when requesting page 2' do
        let(:page) { 2 }
        it 'gets videos with expected attributes' do
          expected_videos = videos[10..14].map { |video| instance_double('Video', user: video.user) }

          expect(Video).to receive(:includes).with(:user).and_return(Video)
          expect(Video).to receive(:newest).and_return(Video)
          expect(Video).to receive(:offset).with(10).and_return(Video)
          expect(Video).to receive(:limit).with(10).and_return(expected_videos)

          operation.call

          expect(operation.videos).to eq(expected_videos)
        end
      end

      context 'when requesting page 3' do
        let(:page) { 3 }
        it 'gets no videos' do
          operation.call
          expect(operation.videos).to be_empty
        end
      end
    end

    context 'when no videos exist' do
      it 'gets no videos' do
        operation.call
        expect(operation.videos).to be_empty
      end
    end
  end
end
