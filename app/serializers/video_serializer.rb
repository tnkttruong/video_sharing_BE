class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :video_id, :detail
  belongs_to :user, serializer: UserSerializer
end
