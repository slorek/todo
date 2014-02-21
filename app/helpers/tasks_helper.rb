module TasksHelper
  def priority_options
    (1..5).to_a
  end
  
  def sort_class(option)
    'active' if (params[:sort] || :name).to_sym == option
  end
end
