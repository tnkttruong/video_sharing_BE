class VideoSerializer < ActiveModel::Serializer
  attributes :title, :video_id, :detail
  has_one :user, serializer: UserSerializer
end
