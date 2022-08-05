class Task < ApplicationRecord
  belongs_to :job_hazard_analysis
  has_many :hazards, dependent: :destroy
  has_many :safeguards, dependent: :destroy
end
