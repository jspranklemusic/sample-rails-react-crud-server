class JobHazardAnalysis < ApplicationRecord
  belongs_to :job
  belongs_to :author
  has_many :tasks, dependent: :destroy
  validates :author_id, :title, :job_id, presence: true
end
