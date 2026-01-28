module Api
  module V1
    module Admin
      class AuditLogsController < ApplicationController
        before_action :authorize_admin!

        def index
          logs = AuditLog.order(created_at: :desc).limit(100)
          
          render json: {
            success: true,
            data: logs,
            total: AuditLog.count
          }
        end

        private

        def authorize_admin!
          token = request.headers['Authorization']&.split(' ')&.last
          if token.blank?
            return render json: { success: false, message: 'Token required' }, status: :unauthorized
          end
          
          begin
            decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
            current_user = User.find_by(id: decoded['user_id'])
            render json: { success: false, message: 'Unauthorized' }, status: :unauthorized unless current_user&.admin?
          rescue JWT::DecodeError
            render json: { success: false, message: 'Invalid token' }, status: :unauthorized
          end
        end
      end
    end
  end
end