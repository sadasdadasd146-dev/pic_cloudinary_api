class DetectNewAssetJob < ApplicationJob
  queue_as :default

  SIMILARITY_THRESHOLD = 90

  def perform(asset_id)
    asset = Asset.select(:id, :user_id, :phash).find_by(id: asset_id)
    return if asset.blank? || asset.phash.blank?

    user_assets = Asset
      .where(user_id: asset.user_id)
      .where.not(id: asset.id)
      .where.not(phash: nil)
      .select(:id, :phash)

    # ✅ Exact duplicate fast path
    exact = user_assets.where(phash: asset.phash)

    exact.each do |dup|
      mark_duplicate(dup.id, 100)
    end

    # เอา exact ออกก่อน compare
    compare_list = user_assets.where.not(phash: asset.phash)

    compare_list.find_each do |other|
      similarity = PhashSimilarity.call(asset.phash, other.phash)
      next if similarity < SIMILARITY_THRESHOLD

      mark_duplicate(other.id, similarity)
    end
  end

  private

  def mark_duplicate(asset_id, similarity)
    JobDelPic.find_or_create_by(asset_id: asset_id) do |j|
      j.similarity = similarity
    end
  end
end
