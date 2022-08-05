class Job < ApplicationRecord
    has_many :job_hazard_analyses
    validates :title, presence: true, uniqueness: true
end
