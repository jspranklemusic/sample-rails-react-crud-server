class JobHazardAnalysesController < ApplicationController
  before_action :set_job_hazard_analysis, only: %i[ show update destroy ]

  # GET /job_hazard_analyses
  def index
    @job_hazard_analyses = JobHazardAnalysis.all
    full_analyses = []
    if !@job_hazard_analyses.nil?
      @job_hazard_analyses.each do |jha|
        populate_tasks(jha,full_analyses)
      end
    end
    render json: full_analyses
  end


  def show
    if !@job_hazard_analysis.nil?
      # return only one task
      render json: populate_tasks(@job_hazard_analysis)[0]
    else
      render json: { error: "JHA doesn't exist" }, status: :not_found
    end
  end

  # POST /job_hazard_analyses
  def create
    ActiveRecord::Base.transaction do
      begin
        # validate
        if !params[:job_hazard_analysis][:job_id] && (!params[:job] || !params[:job][:title])
          raise "Must have either a :job_id, or a :job parameter with a title."
        end
         # set JOB
        if params[:job]
          @job = Job.new( :title => params[:job][:title] )
          # description is optional
          @job[:description] = params[:job][:description] if !params[:job][:description].nil?
          @job.save!
        else
          @job = Job.find(params[:job_hazard_analysis][:job_id])
        end
        # create JHA
        @job_hazard_analysis = JobHazardAnalysis.new(
          :job_id => @job.id,
          :title => params[:title],
          :summary => params[:summary],
          :author_id => params[:author_id]
        )
        @job_hazard_analysis.save!
        @tasks = []

        # create TASKS from new JHA
        params[:tasks].each do |task|
          new_task = @job_hazard_analysis.tasks.create(:description => task[:description])
          @tasks.push(new_task)
          # create HAZARDS from TASKS
          task[:hazards].each do |hazard|
            new_task.hazards.create! description: hazard[:description]
          end
          # create SAFEGUARDS from TASKS
          task[:safeguards].each do |safeguard|
            new_safeguard = new_task.safeguards.create! description: safeguard[:description]
            new_safeguard.save!
          end
          # return the RESULT to the client
        end
        render json: @job_hazard_analysis, :tasks => @tasks, status: :created, location: @job_hazard_analysis
      rescue => exception
        render json: exception, status: :unprocessable_entity
      end
    end    
  end

  # PATCH/PUT /job_hazard_analyses/1
  def update
    if @job_hazard_analysis.update(job_hazard_analysis_params)
      # check if there are any differences between the saved tasks/hazards/safeguards
      update_tasks(@job_hazard_analysis.tasks, params[:tasks])
      render json: params
    else
      render json: @job_hazard_analysis.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_hazard_analyses/1
  def destroy
    @job_hazard_analysis.destroy
  end

  # HELPER METHODS TO USE #############################################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_hazard_analysis
      @job_hazard_analysis = JobHazardAnalysis.find(params[:id])
    end

    # used in PUT request
    def update_tasks(old_tasks, new_tasks)
      # update old tasks first
      old_tasks.each do |old_task|
        new_task = new_tasks.find do |task| task[:id] == old_task[:id] end
        # if there is no matching new parameter, delete the old task
        if new_task.nil?
          old_task.destroy
        else
          new_task.each do |task_key, task_val|
            # update the hazards and safeguards
            if task_key == "hazards"
              update_subitems(old_task.hazards, new_task[:hazards], old_task, "hazards")              
            elsif task_key == "safeguards"
              update_subitems(old_task.safeguards, new_task[:safeguards], old_task, "safeguards")
            else 
              # modify the values
              old_task[task_key] = task_val
            end
          end
          old_task.save!
        end
      end
      # then create new tasks
      new_tasks.each do |new_task|
        # if new task doesn't have an id, it hasn't been created yet
        if new_task[:id].nil?
            new_task_object = @job_hazard_analysis.tasks.create! description: new_task[:description]
            new_task_object.save!
            new_task[:hazards].each do |hazard|
              new_hazard_object = new_task_object.hazards.create! description: hazard[:description]
              new_hazard_object.save!
            end
            new_task[:safeguards].each do |safeguard|
              new_safeguard_object = new_task_object.safeguards.create! description: safeguard[:description]
              new_safeguard_object.save!
            end
        end
      end
    end

    # update hazards or safeguards
    def update_subitems(old_subitems, new_subitems, task, subitem_name)
        # if there is no matching new parameter, delete the old subitem
      old_subitems.each do |old_subitem|
        new_subitem = new_subitems.find do |subitem| subitem[:id] == old_subitem[:id] end
        if new_subitem.nil?
          old_subitem.destroy
        else 
          # otherwise, update the values
          new_subitem.each do |subitem_key, subitem_val|
            old_subitem[subitem_key] = subitem_val
          end
          old_subitem.save!
        end
      end
      # create new
      new_subitems.each do |new_subitem|
        # if item doesn't have id, it hasn't been created yet
        if new_subitem[:id].nil?
          new_subitem_object = task.send(subitem_name).create! description: new_subitem[:description]
          puts new_subitem_object
          new_subitem_object.save!
        end
      end
    end


    def populate_tasks(jha,full_analyses=[])
        new_obj = {}
        # attach job
        new_obj[:job] = jha.job
        # attach author
        new_obj[:author] = jha.author.attributes.except("password")
        jha.attributes.each do |key, val|
          new_obj[key] = val
        end
        # attach tasks
        tasks = jha.tasks
        new_tasks = []
        tasks.each do |task|
          # attach hazards and safeguards
          new_task = {:hazards => task.hazards, :safeguards => task.safeguards}
          task.attributes.each do |key, val|
            new_task[key] = val
          end
          new_tasks.push(new_task)
        end
        new_obj[:tasks] = new_tasks
        full_analyses.push(new_obj)
    end

    # Only allow a list of trusted parameters through.
    def job_hazard_analysis_params
      params.permit(:title, :summary, :author_id, :job_id)
    end
end
