module ApplicationHelper
  def form_error_messages(resource)
    return if resource.errors.empty?
    render partial: 'shared/flash', locals: { messages: { error: resource.errors.full_messages } }
  end
  
  def priority_options
    (1..5).to_a
  end
end
