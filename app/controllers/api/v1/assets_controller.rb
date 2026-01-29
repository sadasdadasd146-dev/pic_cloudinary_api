# app/controllers/api/v1/assets_controller.rb
module Api
  module V1
    class AssetsController < ApplicationController
      include Authenticable
      before_action :authenticate_request

      def index
        limit = params.fetch(:limit, 20).to_i
        page  = params.fetch(:page, 1).to_i

        limit = 100 if limit > 100
        offset = (page - 1) * limit

        sort  = params.fetch(:sort, 'created_at')
        order = params.fetch(:order, 'desc')

        assets = Asset.all

        # 🔥 filter image / video
        if params[:media_type].present?
          assets = assets.where(media_type: params[:media_type])
        end

        total = assets.count

        assets = assets
          .order("#{sort} #{order}")
          .limit(limit)
          .offset(offset)

        render json: {
          success: true,
          data: assets,
          meta: {
            page: page,
            limit: limit,
            total: total,
            total_pages: (total.to_f / limit).ceil,
            media_type: params[:media_type]
          }
        }
      end


      def create
        asset = Asset.new(asset_params)

        if asset.save
          render json: {
            success: true,
            message: 'Asset created successfully',
            data: asset
          }, status: :created
        else
          render json: {
            success: false,
            errors: asset.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        asset = Asset.find(params[:id])

        asset.destroy
        render json: {
          success: true,
          message: 'Asset deleted successfully'
        }
      rescue ActiveRecord::RecordNotFound
        render json: { success: false, message: 'Asset not found' }, status: :not_found
      end

      private

      def asset_params
        params.require(:asset).permit(
          :creator_id,
          :url,
          :cloudinary_id,
          :title,
          :description
        )
      end
    end
  end
end


