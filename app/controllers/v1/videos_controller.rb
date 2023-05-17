class V1::VideosController < AuthenticationController
  def index
    operator = V1::Videos::IndexOperation.new(params, current_user)
    operator.call
    render_json({
      data: operator.videos,
      serializer: VideoSerializer,
      is_array: true
    })
  end

  def create
    operator = V1::Videos::CreateOperation.new(params, current_user)
    operator.call
    render_json({
      data: true,
    })
  end
end
