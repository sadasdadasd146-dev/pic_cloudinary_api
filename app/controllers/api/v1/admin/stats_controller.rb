module Api::V1
  module Admin
    class StatsController < ::Api::V1::BaseController
      def index
        top_contributors = User.joins(:assets)
          .select("users.id, users.name, users.avatar, COUNT(media.id) as total")  # เปลี่ยนจาก assets.id เป็น media.id
          .group("users.id, users.name, users.avatar")
          .order("total DESC")
          .limit(10)
          .map do |user|
            {
              creatorId: user.id.to_s,
              name: user.name || user.username,
              avatar: user.avatar,
              total: user.total.to_i
            }
          end

        render json: {
          totalAssets: Asset.count,
          totalUsers: User.count,
          topContributors: top_contributors
        }
      end
    end
  end
end