class Asset < ApplicationRecord
  has_many :job_del_pics, dependent: :destroy

  belongs_to :creator, optional: true
  belongs_to :user

  validates :url, presence: true

  # ยิง job หลัง commit จริงเท่านั้น
  after_commit :enqueue_generate_phash_job, on: :create

  private

  def enqueue_generate_phash_job
    GeneratePhashJob.perform_later(id)
  end
end
