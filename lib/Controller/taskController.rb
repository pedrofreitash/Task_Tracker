require_relative "../Model/task"

class TaskController
  
  def index
    task = Task.all
  end

  def show(param)
    Task.find(param)
  end

  def create(param)
    task = Task.new(param)
    task.insert
  end

  def destroy(param)
    task = Task.find(param)

    if task
      task.delete
      "Task deletada"
    else
      "Task não localizada"
    end

  end

  def update(param, new_descripiton)
    task = Task.find(param)
    if task
      task.description = new_descripiton
      task.update
      puts "Task #{param} atualizada"
    else
      "Task não localizada"
    end
  end 

end