# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      include Authenticable
      before_action :set_user, only: [:show, :assets]

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
        limit = params.fetch(:limit, 20).to_i
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

      private

      def set_user
        @user = User.find_by(id: params[:id])
        return if @user

        render json: { success: false, message: 'User not found' }, status: :not_found
      end
    end
  end
end
