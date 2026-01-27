module Api::V1
  class CreatorsController < BaseController
    def index
      query = params[:q].presence
      limit = (params[:limit] || 20).to_i
      offset = (params[:offset] || 0).to_i

      creators = ::User.all  # ใช้ ::User
      creators = creators.where("name ILIKE ? OR role ILIKE ?", "%#{query}%", "%#{query}%") if query
      creators = creators.offset(offset).limit(limit)
      total = ::User.count  # ใช้ ::User

      render json: {
        items: creators.map { |u| serialize_creator(u) },
        total: total
      }
    end

    def show
      user = ::User.find(params[:id])  # ใช้ ::User
      render json: serialize_creator(user)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Creator not found' }, status: :not_found
    end

    def media
    user = ::User.find(params[:id])
    media_items = user.assets  # เปลี่ยนจาก user.media เป็น user.assets
    media_items = media_items.where(media_type: params[:type]) if params[:type].in?(%w[image video])

    render json: media_items.map { |m| serialize_media(m) }
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Creator not found' }, status: :not_found
    end

    def update
      user = ::User.find(params[:id])  # ใช้ ::User
      user.update!(creator_params)
      render json: serialize_creator(user)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Creator not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private
    def serialize_creator(user)
      {
        id: user.id.to_s,
        name: user.name || user.username,
        role: user.role || 'creator',
        avatar: user.avatar,
        bio: user.bio,
        previews: user.previews || [],
        isVerified: user.is_verified
      }
    end

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

    def creator_params
        # รับพารามิเตอร์ทั้งแบบตรงและแบบซ้อน
        if params[:creator].present?
            params.require(:creator).permit(:role, :name, :avatar, :bio, :is_verified, previews: [])
        else
            params.permit(:role, :name, :avatar, :bio, :is_verified, previews: [])
        end
    end



  end
end