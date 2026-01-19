class Medium < ApplicationRecord
  belongs_to :user

  enum :media_type, {
    image: "image",
    video: "video"
  }

  validates :url, presence: true
  validates :url, uniqueness: { scope: [:user_id, :media_type] }
end
