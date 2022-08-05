class JobsController < ApplicationController
  # GET /jobs
  def index
    @jobs = Job.all
    render json: @jobs
  end
end
