class PagesController < ApplicationController
  def index
    redirect_to tasks_path if signed_in?
  end
  
  def documentation
  end
  
  def api
  end
end
