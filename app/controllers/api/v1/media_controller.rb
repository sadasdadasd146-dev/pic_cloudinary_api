module Api::V1
  class MediaController < BaseController
    def index
      query = params[:q].presence
      type = params[:type]
      limit = (params[:limit] || 20).to_i
      offset = (params[:offset] || 0).to_i

      media_items = Asset.all  # เปลี่ยนเป็น Asset
      media_items = media_items.where("title ILIKE ? OR ? = ANY(tags)", "%#{query}%", query) if query
      media_items = media_items.where(media_type: type) if type && type != 'all'
      media_items = media_items.offset(offset).limit(limit)
      total = Asset.count  # เปลี่ยนเป็น Asset

      render json: {
        items: media_items.map { |m| serialize_media(m) },
        total: total
      }
    end

    def create
      media = Asset.new(media_params)  # เปลี่ยนเป็น Asset
      media.upload_date ||= Time.current
      media.save!
      render json: serialize_media(media), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def destroy
      media = Asset.find(params[:id])  # เปลี่ยนเป็น Asset
      media.destroy!
      render json: { success: true }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Media not found' }, status: :not_found
    end

    private
    def serialize_media(media)
      {
        id: media.id.to_s,
        title: media.title,
        authorId: media.user_id.to_s,
        author: media.author_name || media.user&.name || media.user&.username,
        authorAvatar: media.author_avatar || media.user&.avatar,
        url: media.url,
        type: media.media_type,
        uploadDate: (media.upload_date || media.created_at).iso8601,
        tags: media.tags || []
      }
    end

    def media_params
        # รับพารามิเตอร์ทั้งแบบตรงและแบบซ้อน
        if params[:medium].present?
            permitted = params.require(:medium).permit(
            :title, :url, :user_id, :type, :media_type, 
            :author_name, :author_avatar, tags: []
            )
        else
            permitted = params.permit(
            :title, :url, :user_id, :type, :media_type, 
            :author_name, :author_avatar, tags: []
            )
        end
        
        # แปลง :type → :media_type ถ้ามี
        if permitted[:type].present? && permitted[:media_type].blank?
            permitted[:media_type] = permitted.delete(:type)
        end
        
        permitted
    end








  end
end