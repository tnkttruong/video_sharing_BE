require 'google/apis/youtube_v3'
require 'googleauth'
class YoutubeService
  def initialize(url)
    @url = url
  end

  def fetch_video_detail
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = ENV['YOUTUBE_API_KEY']
    video_id = get_video_id
    response = youtube.list_videos('snippet', id: video_id)
    {
      title: response.items[0].snippet.title,
      detail: response.items[0].snippet.description,
      id: video_id
    }
  rescue => e
    Rails.logger.error("YoutubeService.fetch_video_detail ERROR")
    Rails.logger.error(e.class.name)
    Rails.logger.error("  type: #{e.class.name}")
    Rails.logger.error("  message: #{e.message}")
    Rails.logger.error("  backtrace:")
    Rails.logger.error("    " + e.backtrace.join("\n    "))
    {}
  end

  private
  def get_video_id
    extract_id_from_url(@url) || extract_id_from_url(get_redirect_url)
  end

  def get_redirect_url
    uri = URI.parse(@url)
    response = Net::HTTP.get_response(uri)
    response.fetch('location')
  rescue
  end

  def extract_id_from_url(url)
    CGI.parse(URI.parse(url).query)['v'].first rescue nil
  end
end

  