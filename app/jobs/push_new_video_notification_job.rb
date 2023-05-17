class PushNewVideoNotificationJob < ApplicationJob
  queue_as :default

  def perform(video)
    return unless video
    client = Firebase::Client.new(ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET_KEY'])
    client.push("videos", { id: video.id, user_email: video.user.email, title: video.title })
  end

end