# app/controllers/api/v1/assets_controller.rb
module Api
  module V1
    class AssetsController < ApplicationController
      before_action :set_asset, only: [:destroy]

      def index
        assets = Asset.all
        render json: {
          success: true,
          data: assets,
          total: assets.count
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
        if @asset.destroy
          render json: {
            success: true,
            message: 'Asset deleted successfully'
          }
        else
          render json: {
            success: false,
            errors: @asset.errors
          }, status: :unprocessable_entity
        end
      end

      private

      def set_asset
        @asset = Asset.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { success: false, message: 'Asset not found' }, status: :not_found
      end

      def asset_params
        params.require(:asset).permit(:creator_id, :url, :cloudinary_id, :title, :description)
      end
    end
  end
end
