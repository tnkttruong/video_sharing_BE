class V1::AuthController < ApplicationController
  def login
    operator = V1::Auth::LoginOperation.new(params)
    operator.call
    render_json({
      data: operator.user,
      serializer: UserSerializer
    })
  end
end
