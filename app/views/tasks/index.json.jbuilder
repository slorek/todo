json.array! @tasks do |task|
  json.id task.id
  json.name task.name
  json.due_date task.due_date
  json.priority task.priority
  json.completed_at task.completed_at
end