class JobStatus < ApplicationRecord
  # prevents duplicate records for the same job (e.g. if a job is retried),
  # which is critical when checking the status by job_id
  validates :job_id, presence: true, uniqueness: true

  validates :status, presence: true
end
