# app/models/asset.rb
class Asset < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :media_type, presence: true

  validates :url, uniqueness: {
    scope: [:user_id, :media_type],
    message: 'already exists for this user and media type'
  }
end
