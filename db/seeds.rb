require 'google/apis/youtube_v3'

youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.key = ENV['YOUTUBE_API_KEY']
10.times do
  user = User.create(
    email: Faker::Internet.email,
    encrypted_password: BCrypt::Password.create('password')
  )
  search_options = {
    q: Faker::Lorem.word,
    type: 'video',
    max_results: 5
  }
  search_results = youtube.list_searches('snippet', search_options)
  video_ids = search_results.items.map do |item| 
    Video.create(
      user: user,
      video_id: item.id.video_id,
      title: item.snippet.title,
      detail: item.snippet.description
    )
  end
end

