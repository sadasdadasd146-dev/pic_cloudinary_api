module Api::V1
  class ResizeController < BaseController
    def show
      url = params[:url]
      width = params[:w].to_i
      height = params[:h].to_i

      return head :bad_request unless url && width.positive? && height.positive?
      return head :forbidden if url !~ /\Ahttps?:\/\//i

      begin
        image = MiniMagick::Image.open(url)
        image.resize "#{width}x#{height}"
        image.format "jpg"
        send_data image.to_blob, type: "image/jpeg", disposition: "inline"
      rescue => e
        Rails.logger.error "Resize failed: #{e.message}"
        head :internal_server_error
      end
    end
  end
end