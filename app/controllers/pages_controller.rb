class PagesController < ApplicationController

  layout 'swagger', only: [:api]

  def index
    redirect_to tasks_path if signed_in?
  end
  
  def api
  end
end
