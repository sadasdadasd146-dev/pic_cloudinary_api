# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      include Authenticable
      before_action :set_user, only: [:show, :assets, :media]

      # GET /api/v1/users
      def index
        page  = params.fetch(:page, 1).to_i
        limit = params.fetch(:limit, 20).to_i
        limit = 100 if limit > 100 # กันยิงหนัก
        offset = (page - 1) * limit

        users = User.all

        # 🔍 search
        if params[:search].present?
          q = "%#{params[:search]}%"
          users = users.where(
            'username ILIKE :q OR name ILIKE :q OR email ILIKE :q',
            q: q
          )
        end

        # ↕️ sort
        sort  = params[:sort].presence_in(%w[id username created_at]) || 'created_at'
        order = params[:order] == 'asc' ? 'asc' : 'desc'
        users = users.order("#{sort} #{order}")

        total = users.count

        users = users.offset(offset).limit(limit)

        render json: {
          success: true,
          data: users,
          meta: {
            page: page,
            limit: limit,
            total: total,
            total_pages: (total / limit.to_f).ceil
          }
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: {
          success: true,
          data: @user
        }
      end

      # GET /api/v1/users/:id/assets
      def assets
        page  = params.fetch(:page, 1).to_i
        limit = params.fetch(:limit, 200).to_i
        offset = (page - 1) * limit

        assets = @user.assets.order(created_at: :desc)
        total = assets.count
        assets = assets.offset(offset).limit(limit)

        render json: {
          success: true,
          data: assets,
          meta: {
            page: page,
            limit: limit,
            total: total
          }
        }
      end

      # app/controllers/api/v1/users_controller.rb
# app/controllers/api/v1/users_controller.rb
    def with_assets
      limit = params[:limit].to_i
      limit = 10 if limit <= 0
      limit = 100 if limit > 100   # กันดูดข้อมูลหนักเกิน

      users = User
        .joins(:assets)
        .select(
          "users.id,
          users.username,
          COUNT(assets.id) AS asset_count,
          SUM(CASE WHEN assets.media_type = 'image' THEN 1 ELSE 0 END) AS image_count,
          SUM(CASE WHEN assets.media_type = 'video' THEN 1 ELSE 0 END) AS video_count"
        )
        .group("users.id, users.username")
        .order("asset_count DESC")
        .limit(limit)

      render json: {
        success: true,
        limit: limit,
        data: users.map { |u|
          {
            id: u.id,
            username: u.username,
            asset_count: u.asset_count.to_i,
            image_count: u.image_count.to_i,
            video_count: u.video_count.to_i
          }
        }
      }
    end



    # GET /api/v1/users/:id/media
    def media
      images = @user.assets.where(media_type: 'image').order(created_at: :desc)
      videos = @user.assets.where(media_type: 'video').order(created_at: :desc)

      render json: {
        success: true,
        user: {
          id: @user.id,
          username: @user.username
        },
        images: {
          total: images.count,
          items: images
        },
        videos: {
          total: videos.count,
          items: videos
        }
      }
    end





      private

      def set_user
        @user = User.find_by(id: params[:id])
        return if @user

        render json: { success: false, message: 'User not found' }, status: :not_found
      end
    end
  end
end
