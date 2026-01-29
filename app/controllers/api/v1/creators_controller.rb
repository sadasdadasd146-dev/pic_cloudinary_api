module Api
  module V1
    class CreatorsController < ApplicationController
      include Authenticable
      before_action :authenticate_request
      before_action :set_creator, only: [:show, :update, :assets]

      # GET /api/v1/creators
      def index
        limit  = params.fetch(:limit, 20).to_i
        page   = params.fetch(:page, 1).to_i
        limit  = 100 if limit > 100
        offset = (page - 1) * limit

        sort   = params.fetch(:sort, 'created_at')
        order  = params.fetch(:order, 'desc')

        creators = Creator
          .order("#{sort} #{order}")
          .limit(limit)
          .offset(offset)

        total = Creator.count

        render json: {
          success: true,
          data: creators,
          meta: {
            page: page,
            limit: limit,
            total: total,
            total_pages: (total.to_f / limit).ceil
          }
        }
      end

      # GET /api/v1/creators/:id
      def show
        render json: {
          success: true,
          data: @creator
        }
      end

      # POST /api/v1/creators
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

      # PATCH /api/v1/creators/:id
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

      # GET /api/v1/creators/:id/assets
      def assets
        limit  = params.fetch(:limit, 20).to_i
        page   = params.fetch(:page, 1).to_i
        limit  = 100 if limit > 100
        offset = (page - 1) * limit

        sort   = params.fetch(:sort, 'created_at')
        order  = params.fetch(:order, 'desc')

        assets = @creator.assets
          .order("#{sort} #{order}")
          .limit(limit)
          .offset(offset)

        total = @creator.assets.count

        render json: {
          success: true,
          data: assets,
          meta: {
            page: page,
            limit: limit,
            total: total,
            total_pages: (total.to_f / limit).ceil
          }
        }
      end

      private

      def set_creator
        @creator = Creator.find_by(id: params[:id])
        return if @creator

        render json: {
          success: false,
          message: 'Creator not found'
        }, status: :not_found
      end

      def creator_params
        params.require(:creator).permit(:name, :description, :email)
      end
    end
  end
end
