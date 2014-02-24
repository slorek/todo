class TasksController < ApplicationController
  
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  
  respond_to :html
  respond_to :json, except: [:edit]
  
  def index
    @task = Task.new
    @tasks = get_all_tasks

    respond_with(@tasks)
  end
  
  def create
    @task = Task.create sanitized_task_params

    respond_with(@task) do |format|
      format.html do
        if @task.errors.empty?
          flash[:notice] = "Task added to your list"
          redirect_to tasks_path
        else
          @tasks = get_all_tasks
          render :index
        end
      end
    end
  end
  
  def destroy
    @task = get_task(params[:id])
    
    if @task.destroy
      flash[:notice] = "Task deleted"
    else
      flash[:error] = @task.errors.full_messages
    end
    
    respond_with(@task)
  end

  def completed
    @task = get_task(params[:id])
    @task.completed_at = Time.now
    
    @task.save
    
    respond_with(@task) do |format|
      format.html do
        if @task.errors.empty?
          flash[:notice] = "Task completed"
          redirect_to tasks_path
        else
          flash[:error] = @task.errors.full_messages
          @tasks = get_all_tasks
          render :index
        end
      end
    end
  end
  
  def edit
    @task = get_task(params[:id])
  end
  
  def update
    @task = get_task(params[:id])
    @task.update_attributes(sanitized_task_params)

    respond_with(@task) do |format|
      format.html do
        if @task.errors.empty?
          flash[:notice] = "Task updated"
          redirect_to tasks_path
        else
          render :edit
        end
      end
    end
  end
  
  
  private
    def sanitized_task_params
      params[:task] ||= {}
      params[:task][:user_id] = current_user.id
      params.require(:task).permit(:user_id, :name, :due_date, :priority, :completed)
    end
    
    def get_task(id)
      Task.where(user_id: current_user.id, id: id).limit(1).first || raise(ActionController::RoutingError.new('Not Found'))
    end
    
    def get_all_tasks
      order = {
        name: :name,
        due_date: 'due_date IS NULL, due_date',
        priority: 'priority IS NULL, priority',
      }[(params[:sort] || :name).to_sym]
      
      scope = params[:completed].present? ? :completed : :pending
      
      Task.send(scope).where(user_id: current_user.id).order(order)
    end
end
