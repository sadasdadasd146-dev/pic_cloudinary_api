module Api
  module V1
    class ResizeController < ApplicationController
      def show
        url = params[:url]
        width = params[:width]
        height = params[:height]
        quality = params[:quality] || 80

        if url.blank?
          return render json: {
            success: false,
            message: 'URL parameter is required'
          }, status: :bad_request
        end

        begin
          # Use Cloudinary transformation
          if url.include?('cloudinary')
            resized_url = Cloudinary::Utils.cloudinary_url(
              url,
              width: width,
              height: height,
              crop: 'fill',
              quality: quality,
              secure: true
            )[0]
          else
            # Generic resize using query params
            resized_url = url + "?w=#{width}&h=#{height}&q=#{quality}"
          end

          render json: {
            success: true,
            data: {
              original_url: url,
              resized_url: resized_url,
              width: width,
              height: height,
              quality: quality
            }
          }
        rescue => e
          render json: {
            success: false,
            message: e.message
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
