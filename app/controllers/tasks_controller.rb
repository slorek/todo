class TasksController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  
  respond_to :html
    
  def index
    @tasks = get_all_tasks
    @task = Task.new
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
  
  private
    def sanitized_task_params
      params[:task] ||= {}
      params[:task][:user_id] = current_user.id
      params.require(:task).permit(:user_id, :name, :due_date, :priority)
    end
    
    def get_task(id)
      Task.where(user_id: current_user.id, id: id).limit(1).first || raise(ActionController::RoutingError.new('Not Found'))
    end
    
    def get_all_tasks
      Task.pending.where(user_id: current_user.id)
    end
end
