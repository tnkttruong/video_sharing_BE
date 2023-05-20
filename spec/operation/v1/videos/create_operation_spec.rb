require 'rails_helper'

RSpec.describe V1::Videos::CreateOperation, type: :operation do
  let(:user) { create(:user) }
  let(:valid_url) { 'https://www.youtube.com/watch?v=abcdefghij' }
  let(:params) { { url: valid_url } }
  let(:operation) { V1::Videos::CreateOperation.new(params, user) }
  let(:video) { create(:video) }

  before do
    allow_any_instance_of(V1::Videos::CreateForm).to receive(:valid!)
    allow_any_instance_of(V1::Videos::CreateForm).to receive(:video).and_return(video)
    allow(video).to receive(:user_id=)
    allow(video).to receive(:save)
  end

  describe '#call' do
    context 'when invalid params' do
      before do
        allow_any_instance_of(V1::Videos::CreateForm).to receive(:valid!).and_raise(ExceptionError::UnprocessableEntity)
      end
      let(:params) { { url: '' } }
      it 'raises an UnprocessableEntity error' do
        expect { operation.call }.to raise_error(ExceptionError::UnprocessableEntity)
      end
    end

    context 'when valid params' do
      it 'validates the form' do
        expect_any_instance_of(V1::Videos::CreateForm).to receive(:valid!)
        operation.call
      end

      it 'saves the video' do
        expect(video).to receive(:user_id=).with(user.id)
        expect(video).to receive(:save)
        operation.call
      end

      it 'pushes a new notification' do
        expect(PushNewVideoNotificationJob).to receive(:perform_later).with(video)
        operation.call
      end
    end
  end
end

