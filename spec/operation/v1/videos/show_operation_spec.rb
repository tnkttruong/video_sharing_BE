require 'rails_helper'

RSpec.describe V1::Videos::ShowOperation, type: :operation do
  let(:video_id) { 1 }
  let(:params) { { id: video_id } }
  let(:operation) { V1::Videos::ShowOperation.new(params) }
  let(:video) { create(:video) }

  describe '#call' do
    context 'when the video exists' do
      let(:video_id) { 1 }
      it 'gets the video with the expected id' do
        expect(Video).to receive(:find).with(video_id).and_return(video)

        operation.call

        expect(operation.video).to eq(video)
      end
    end

    context 'when the video does not exist' do
      let(:video_id) { 2 }

      it 'raises an exception' do
        expect { operation.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
