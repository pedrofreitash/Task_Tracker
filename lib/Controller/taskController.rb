require_relative "../Model/task"

class TaskController
  
  def index
    Task.all
  end

  def show(param)
    Task.find(param)
  end

  def search_by_status(filter)
    Task.where(status: filter)
  end

  def create(param)
    task = Task.new(description: param)
    task.insert
  end

  def destroy(param)
    task = Task.find(param)

    if task
      task.delete
    else
      "Task não localizada"
    end

  end

  def update(param, value)
    task = Task.find(param)
    return nil unless task

    task.description = value
    task.update

  end

  def mark_in_progress(param)
    task = Task.find(param)
    return nil unless task

    task.status = StatusTask::STATUS_TASK[:in_progress]
    task.update
  end

  def mark_done(param)
    task = Task.find(param)
    return nil unless task

    task.status = StatusTask::STATUS_TASK[:done]
    task.update
  end

end