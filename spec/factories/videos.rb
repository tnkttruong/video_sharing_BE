FactoryBot.define do
  factory :video do
    user
    video_id { "someVideoId" }
    title { "Some Title" }
    detail { "Some detail about the video." }
  end
end