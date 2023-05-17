module Renderable
  extend ActiveSupport::Concern

  def render_error(messages, status = 400, code = 0)
    render json: {
      code: code,
      error: messages,
      data: ''
    }, status: status
  end

  def render_json(render_params = {})
    data = render_params[:data]
    serializer = render_params[:serializer]
    status = render_params[:status] || 200
    is_array = render_params[:is_array]
    return render(json: data, status: status) if !serializer || data.blank?
    is_array ? render(json: data, each_serializer: serializer) : render(json: data, serializer: serializer)
  end
end
