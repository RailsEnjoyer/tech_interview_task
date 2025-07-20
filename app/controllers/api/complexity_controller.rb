class Api::ComplexityController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    words = params[:_json]

    return render json: { error: "Words must be an array" }, status: :unprocessable_entity unless words.is_a?(Array)

    # creating random job_id
    job_id = SecureRandom.uuid
    JobStatus.create!(job_id: job_id, status: "pending")

    CalculateComplexityJob.perform_later(words, job_id)

    # renders JSON response with job_id for copying/using (e.g. {"job_id":"fdc6af63-a190-4432-99ce-3cb10912c426"})
    render json: { job_id: job_id }, status: :accepted
  end

  def show
    job = JobStatus.find_by(job_id: params[:id])

    return render json: { error: "Job not found" }, status: :not_found unless job

    if job.status == "completed"
      render json: { status: "completed", result: job.result }, status: :ok
    else
      render json: { status: job.status }, status: :ok
    end
  end
end
