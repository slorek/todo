module ApplicationHelper
  def form_error_messages(resource)
    return if resource.errors.empty?

    messages = resource.errors.full_messages.map {|msg| content_tag(:p, msg) }.join

    render partial: 'shared/flash', locals: { messages: { error: messages } }
  end
end
