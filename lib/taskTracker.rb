require_relative "Db/setupDatabase"
require_relative "Model/task"
require_relative "Model/statusTask"
setup_tables()

def mostrar_objeto(task)
  if task.is_a?(Array)
  task.each do |t|
    puts "id: #{t.id} - description: #{t.description} - Status: #{t.status} - CreatedAt: #{t.created_at} - UpdatedAt: #{t.updated_at}"
  end
  else
    puts "id: #{task.id} - description: #{task.description} - Status: #{task.status} - CreatedAt: #{task.created_at} - UpdatedAt: #{task.updated_at}"
  end
end




task = Task.find(2)
task.status = StatusTask::STATUS_TASK[1]
task.update

task = Task.find(3)
task.status = StatusTask::STATUS_TASK[2]
task.update

task = Task.where(StatusTask::STATUS_TASK[2])
mostrar_objeto(task)
# task = Task.where(StatusTask::STATUS_TASK[1])
# mostrar_objeto(task)
# task = Task.where(StatusTask::STATUS_TASK[2])
# mostrar_objeto(task)