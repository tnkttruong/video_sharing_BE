class V1::Videos::ShowOperation < ApplicationOperation
  attr_accessor :video

  def call
    get_videos
  end

  private

  def get_videos
    @video = Video.find(params[:id])
  end
end
