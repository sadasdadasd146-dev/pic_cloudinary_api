class Creator < ApplicationRecord
  belongs_to :user, optional: true
  has_many :assets, dependent: :destroy
  
  validates :name, presence: true
  validates :email, uniqueness: true, allow_nil: true
end
