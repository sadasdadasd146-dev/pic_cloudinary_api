module Api
  module V1
    module Admin
      class StatsController < ApplicationController
        include Authenticable
        before_action :authorize_admin!

        def index
          stats = {
            total_creators: Creator.count,
            total_assets: Asset.count,
            total_users: User.count,
            total_audit_logs: AuditLog.count,
            assets_per_creator: Creator.includes(:assets).map { |c| { creator: c.name, count: c.assets.count } }
          }

          render json: {
            success: true,
            data: stats
          }
        end
      end
    end
  end
end