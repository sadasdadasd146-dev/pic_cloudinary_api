class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  def login
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)

      render json: {
        token: token,
        user: {
          id: user.id,
          username: user.username,
          role: user.role
        }
      }
    else
      render json: { error: "username หรือ password ไม่ถูกต้อง" }, status: :unauthorized
    end
  end
end
