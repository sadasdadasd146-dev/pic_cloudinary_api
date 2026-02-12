class DeleteMarkedImagesJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 200

  def perform
    JobDelPic
      .includes(:asset)
      .find_in_batches(batch_size: BATCH_SIZE) do |batch|

      batch.each do |job|
        asset = job.asset
        next unless asset

        begin
          # TODO: ลบ cloudinary
          # Cloudinary::Uploader.destroy(asset.public_id)

          asset.destroy!
          job.destroy!

        rescue => e
          Rails.logger.error("Delete fail asset #{job.asset_id}: #{e.message}")
        end
      end
    end
  end
end
