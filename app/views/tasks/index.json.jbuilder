json.set! :pending_count, @pending_badge
json.set! :completed_count, @completed_badge
json.set! :tasks do
  json.array! @tasks, :id, :name, :due_date, :priority, :completed_at
end