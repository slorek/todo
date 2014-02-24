module TasksHelper
  def priority_options
    {
      1 => 'Low',
      2 => 'Minor',
      3 => 'Normal',
      4 => 'High',
      5 => 'Urgent'
    }
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
