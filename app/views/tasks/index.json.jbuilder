json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description, :status, :section_id, :assingnee_id, :created_by, :due_date
  json.url task_url(task, format: :json)
end
