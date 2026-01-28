class User < ApplicationRecord
  has_secure_password

  has_many :assets, foreign_key: :user_id, dependent: :destroy, class_name: "Asset"

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }



  
end