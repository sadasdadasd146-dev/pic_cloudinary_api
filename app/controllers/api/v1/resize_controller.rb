module Api::V1
  class ResizeController < BaseController
    skip_before_action :authenticate_user!, only: :show

    def show
      url    = params[:url]
      width  = params[:w].to_i
      height = params[:h].to_i

      return head :bad_request unless url.present? && width.positive? && height.positive?
      return head :forbidden unless url =~ /\Ahttps?:\/\//i

      image = MiniMagick::Image.open(url)
      image.resize "#{width}x#{height}"
      image.format "jpg"

      send_data image.to_blob,
                type: "image/jpeg",
                disposition: "inline"
    rescue => e
      Rails.logger.error "[Resize] #{e.message}"
      head :internal_server_error
    end
  end
end
