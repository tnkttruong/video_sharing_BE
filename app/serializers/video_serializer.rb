class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :video_id, :detail
  has_one :user, serializer: UserSerializer
end
