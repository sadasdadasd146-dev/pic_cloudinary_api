require "open-uri"
require "tempfile"

class GeneratePhashJob < ApplicationJob
  queue_as :default

  retry_on OpenURI::HTTPError, wait: :exponentially_longer, attempts: 5
  retry_on Net::ReadTimeout, Timeout::Error, wait: 10.seconds, attempts: 3

  def perform(asset_id)
    asset = Asset.find_by(id: asset_id)
    return unless asset

    # กัน race condition
    return unless asset.phash.nil?

    Rails.logger.info "[pHash] start asset=#{asset.id}"

    URI.open(
      asset.url,
      read_timeout: 10,
      open_timeout: 5
    ) do |remote_file|

      Tempfile.create(["phash", ".jpg"]) do |tmp|
        tmp.binmode

        IO.copy_stream(remote_file, tmp) # 🔥 stream ไม่กิน RAM
        tmp.rewind

        # hash = Phashion.image_hash(tmp.path)
        hash = DHashVips::IDHash.fingerprint(tmp.path)


        asset.update_columns(
          phash: hash.to_s(16),
          updated_at: Time.current
        )

      end
    end

    Rails.logger.info "[pHash] done asset=#{asset.id}"

  rescue => e
    Rails.logger.error "[pHash] fail asset=#{asset_id} error=#{e.class} #{e.message}"
    raise e
  end
end






