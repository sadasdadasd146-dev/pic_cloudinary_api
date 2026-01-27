class User < ApplicationRecord
  has_many :assets, foreign_key: :user_id, dependent: :destroy, class_name: "Asset"
end