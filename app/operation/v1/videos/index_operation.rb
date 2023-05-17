class V1::Videos::IndexOperation < ApplicationOperation
  attr_accessor :videos

  def call
    get_videos
  end

  private

  def get_videos
    @videos = Video.includes(:user).newest.offset(query_offset*query_limit).limit(query_limit)
  end
end
