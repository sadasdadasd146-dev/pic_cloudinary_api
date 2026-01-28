module Api::V1
  class MediaController < BaseController
    def index
      query  = params[:q].presence
      type   = params[:media_type]
      limit  = (params[:limit] || 20).to_i
      offset = (params[:offset] || 0).to_i

      assets = Asset.all
      assets = assets.where(media_type: type) if type.present? && type != "all"

      if query
        assets = assets.where(
          "title ILIKE :q OR :q = ANY(tags)",
          q: query
        )
      end

      total = assets.count

      assets = assets.offset(offset).limit(limit)

      render json: {
        items: assets.map { |a| serialize_asset(a) },
        total: total
      }
    end

    def create
      asset = Asset.create!(asset_params.merge(upload_date: Time.current))
      render json: serialize_asset(asset), status: :created
    end

    def destroy
      Asset.find(params[:id]).destroy!
      render json: { success: true }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Asset not found" }, status: :not_found
    end

    private

    def serialize_asset(asset)
      {
        id: asset.id.to_s,
        title: asset.title,
        authorId: asset.user_id.to_s,
        author: asset.author_name || asset.user&.name || asset.user&.username,
        authorAvatar: asset.author_avatar || asset.user&.avatar,
        url: asset.url,
        type: asset.media_type,
        uploadDate: (asset.upload_date || asset.created_at).iso8601,
        tags: asset.tags || []
      }
    end

    def asset_params
      params.permit(
        :title,
        :url,
        :user_id,
        :media_type,
        :author_name,
        :author_avatar,
        tags: []
      )
    end
  end
end
