class Asset < ApplicationRecord
  self.table_name = "media"
  
  belongs_to :user, foreign_key: :user_id

  # ลบบรรทัดนี้ออกชั่วคราวเพื่อทดสอบ
  # enum media_type: { image: "image", video: "video" }

  validates :url, presence: true
  validates :url, uniqueness: { scope: [:user_id, :media_type] }
end