# app/models/asset.rb
class Asset < ApplicationRecord
  belongs_to :creator
  
  validates :url, presence: true
  validates :creator_id, presence: true
end
