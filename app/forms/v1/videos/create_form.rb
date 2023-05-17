class V1::Videos::CreateForm < ApplicationForm
  attribute :video
  attribute :url

  validates :url, presence: true
  with_options if: :url do
    validate :check_url_valid
  end

  def initialize(attributes = {})
    youtube_data = YoutubeService.new(attributes[:url]).fetch_video_detail
    if youtube_data.present?
      attributes[:video] = Video.new(
        title: youtube_data[:title],
        detail: youtube_data[:detail],
        video_id: youtube_data[:id]
      )
    end
    super(attributes)
  end

  private
  def check_url_valid
    errors.add(:url, :invalid) unless video
  end
end
