require_relative "../Controller/taskController"


command = ARGV[0]
param = ARGV[1]
update_descripiton = ARGV[2]

controller = TaskController.new

def show_task(task)
  if task.is_a?(Array)
    task.each do |t|
      puts "ID: #{t.id} - Descrição: #{t.description} - Status: #{t.status}"
    end
  else
    puts "ID: #{task.id} - Descrição: #{task.description} - Status: #{task.status}"
  end
end

case command
when 'add'
  task = controller.create(param)
  puts "Adicionado task - ID: #{task.id}"

when 'list'
  tasks = nil
  if param
    tasks = controller.show(param)
  else
    tasks = controller.index
  end
  show_task(tasks)

when 'delete'
  controller.destroy(param)
  puts "Deletar task #{param}"

when 'update'
  controller.update(param, update_descripiton)
else
  puts "Invalido"
end

