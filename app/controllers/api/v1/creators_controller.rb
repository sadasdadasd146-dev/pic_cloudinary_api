module Api
  module V1
    class CreatorsController < ApplicationController
      before_action :set_creator, only: [:show, :update, :assets]

      def index
        creators = Creator.all
        render json: {
          success: true,
          data: creators,
          total: creators.count
        }
      end

      def show
        render json: {
          success: true,
          data: @creator
        }
      end

      def create
        creator = Creator.new(creator_params)
        
        if creator.save
          render json: {
            success: true,
            message: 'Creator created successfully',
            data: creator
          }, status: :created
        else
          render json: {
            success: false,
            errors: creator.errors
          }, status: :unprocessable_entity
        end
      end

      def update
        if @creator.update(creator_params)
          render json: {
            success: true,
            message: 'Creator updated successfully',
            data: @creator
          }
        else
          render json: {
            success: false,
            errors: @creator.errors
          }, status: :unprocessable_entity
        end
      end

      def assets
        assets = @creator.assets
        render json: {
          success: true,
          data: assets,
          total: assets.count
        }
      end

      private

      def set_creator
        @creator = Creator.find_by(id: params[:id])
        unless @creator
          render json: { success: false, message: 'Creator not found' }, status: :not_found
        end
      end

      def creator_params
        params.require(:creator).permit(:name, :description, :email)
      end
    end
  end
end