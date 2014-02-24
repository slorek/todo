module TasksHelper
  def priority_options
    (1..5).to_a
  end
  
  def sort_class(option)
    'active' if (params[:sort] || :name).to_sym == option
  end

  def completed_class(option)
    return 'active' if (option == :pending) && !params[:completed]
    return 'active' if (option == :completed) && params[:completed]
    return ''
  end
end
