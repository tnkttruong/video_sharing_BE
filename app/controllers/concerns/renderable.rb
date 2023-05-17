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
    object = render_params[:object]
    serializer = render_params[:serializer]
    status = render_params[:status] || 200
    code = render_params[:code] || 1
    meta = render_params[:meta]
    is_array = render_params[:is_array]
    if serializer
      if is_array
        render json: object, each_serializer: serializer
      else
        render json: object, serializer: serializer
      end
    else
      render json: object, status: status
    end
  end
end
