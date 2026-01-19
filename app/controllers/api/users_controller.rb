class Api::UsersController < ApplicationController
  def top
    limit = [params.fetch(:limit, 10).to_i, 50].min
    type  = params[:type]

    users = User
      .joins(:media)
      .yield_self { |q|
        type.present? ? q.where(media: { media_type: type }) : q
      }
      .select(
        "users.id, users.username, COUNT(media.id) AS media_count"
      )
      .group("users.id")
      .order("media_count DESC")
      .limit(limit)

    render json: users.map { |u|
      {
        username: u.username,
        total_media: u.media_count.to_i
      }
    }
  end
end
