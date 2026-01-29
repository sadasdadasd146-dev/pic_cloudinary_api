module Api
  module V1
    class AuthController < ApplicationController
      include Authenticable
      skip_before_action :authenticate_request, only: [:login]

      def login
        user = User.find_by(username: auth_params[:username])

        Rails.logger.debug("User found: #{user.inspect}")
        Rails.logger.debug("Password authenticate result: #{user&.authenticate(auth_params[:password])}")

        if user&.authenticate(auth_params[:password])
          token = encode_token(user.id)
          render json: {
            success: true,
            message: 'Login successful',
            data: {
              user_id: user.id,
              username: user.username,
              token: token
            }
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Invalid username or password'
          }, status: :unauthorized
        end
      end

      private

      def auth_params
        params.require(:auth).permit(:username, :password)
      end

      def encode_token(user_id)
        JWT.encode(
          { user_id: user_id, exp: 24.hours.from_now.to_i },
          Rails.application.secret_key_base
        )
      end
    end
  end
end
