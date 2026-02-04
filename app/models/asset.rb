class Asset < ApplicationRecord
  belongs_to :creator, optional: true
  belongs_to :user

  validates :url, presence: true
end
