class Api::MediaController < ApplicationController


def bulk_create
  payload = params.require(:_json)

  created = 0
  skipped = 0

  ActiveRecord::Base.transaction do
    payload.each do |item|
      username = item[:user].to_s.strip
      next if username.blank?

      user = User.find_or_create_by!(username: username)

      Array(item[:images]).each do |url|
        record = user.media.find_or_create_by(
          media_type: "image",
          url: url
        )
        record.persisted? ? created += 1 : skipped += 1
      end

      Array(item[:videos]).each do |url|
        record = user.media.find_or_create_by(
          media_type: "video",
          url: url
        )
        record.persisted? ? created += 1 : skipped += 1
      end
    end
  end

  render json: {
    status: "ok",
    created: created,
    skipped: skipped
  }
end





def bulk_create2
    payload = params.require(:_json)

    now = Time.current
    rows = []

    payload.each do |item|
    username = item[:user].to_s.strip
    next if username.blank?

    user = User.find_or_create_by!(username: username)

    Array(item[:images]).each do |url|
        rows << {
        user_id: user.id,
        media_type: "image",
        url: url,
        created_at: now,
        updated_at: now
        }
    end

    Array(item[:videos]).each do |url|
        rows << {
        user_id: user.id,
        media_type: "video",
        url: url,
        created_at: now,
        updated_at: now
        }
    end
    end

    inserted = 0

    rows.each_slice(5_000) do |batch|
    result = Medium.insert_all(
        batch,
        unique_by: %i[user_id media_type url]
    )
    inserted += result.rows.count
    end

    render json: {
    status: "ok",
    inserted: inserted,
    received: rows.size,
    skipped: rows.size - inserted
    }
end





# def by_user
#     user = User.find_by!(username: params[:username])

#     media = user.media
#     media = media.where(media_type: params[:type]) if params[:type].present?

#     page = params.fetch(:page, 1).to_i
#     per  = [params.fetch(:per, 50).to_i, 100].min

#     media = media
#             .order(id: :desc)
#             .limit(per)
#             .offset((page - 1) * per)

#     render json: {
#     user: user.username,
#     type: params[:type] || "all",
#     page: page,
#     per: per,
#     total: user.media.count,
#     data: media.select(:id, :media_type, :url)
#     }
# end



def by_user
    user = User.find_by!(username: params[:username])

    media = user.media

    if params[:type].present?
        media = media.where(media_type: params[:type].split(","))
    end

    if params[:url].present?
        media = media.where("url ILIKE ?", "%#{params[:url]}%")
    end

    if params[:from].present?
        media = media.where("created_at >= ?", params[:from])
    end

    if params[:to].present?
        media = media.where("created_at <= ?", params[:to])
    end

    per  = [params.fetch(:per, 50).to_i, 100].min
    page = params.fetch(:page, 1).to_i

    media = media.order(id: :desc)
                .limit(per)
                .offset((page - 1) * per)

    render json: {
        user: user.username,
        type: params[:type] || "all",
        page: page,
        per: per,
        data: media.select(:id, :media_type, :url)
    }
end







def bulk_delete
    user = User.find_by!(username: params[:username])

    scope = user.media
    scope = scope.where(media_type: params[:type]) if params[:type].present?

    deleted = 0

    if params[:ids].present?
    deleted = scope.where(id: params[:ids]).delete_all

    elsif params[:urls].present?
    deleted = scope.where(url: params[:urls]).delete_all

    else
    return render json: {
        error: "ids or urls is required"
    }, status: :unprocessable_entity
    end

    render json: {
    status: "ok",
    deleted: deleted
    }
end
















end
