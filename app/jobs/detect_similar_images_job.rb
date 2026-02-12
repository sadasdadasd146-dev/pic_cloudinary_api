class DetectSimilarImagesJob < ApplicationJob
  queue_as :default

  def perform
    return unless allowed_time?

    assets = Asset
              .select(:id, :user_id, :phash)
              .where.not(phash: nil)
              .order(:user_id)

    assets.group_by(&:user_id).each do |_uid, user_assets|
      next if user_assets.size < 2

      visited = {}
      groups  = []

      user_assets.each do |asset|
        next if visited[asset.id]

        group = [asset]
        visited[asset.id] = true

        user_assets.each do |other|
          next if asset.id == other.id
          next if visited[other.id]

          similarity = PhashSimilarity.call(asset.phash, other.phash)

          if similarity >= 90
            group << other
            visited[other.id] = true
          end
        end

        groups << group if group.size > 1
      end

      groups.each do |group|
        base = group.first

        group[1..].each do |dup|
          similarity = PhashSimilarity.call(base.phash, dup.phash)

          JobDelPic.find_or_create_by(asset_id: dup.id) do |j|
            j.similarity = similarity
          end
        end
      end
    end
  end

  private

  def allowed_time?
    true
  end
end
