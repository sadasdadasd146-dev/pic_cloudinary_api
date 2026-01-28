class User < ApplicationRecord
  has_secure_password

  has_many :creators, dependent: :destroy
  has_many :audit_logs, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true
end