class BackfillPhashJob < ApplicationJob
  queue_as :default

  def perform
    Asset.where(phash: nil).find_each do |asset|
      GeneratePhashJob.perform_later(asset.id)
    end
  end
end
