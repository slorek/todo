class TasksController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  
  before_filter :get_tasks
  
  def index
    @task = Task.new
  end
  
  def create
    @task = Task.new sanitized_task_params
    if @task.save
      flash[:notice] = "Task added to your list"
      redirect_to tasks_path
    else
      render :index
    end
  end
  
  private
    def sanitized_task_params
      params[:task] ||= {}
      params[:task][:user_id] = current_user.id
      params.require(:task).permit(:user_id, :name, :due_date, :priority)
    end
    
    def get_tasks
      @tasks = Task.pending.where(user_id: current_user)
    end
end
