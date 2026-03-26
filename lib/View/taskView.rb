require_relative "../Controller/taskController"

class TaskView
  def self.run(args)
    command = ARGV[0]
    param = ARGV[1]

    controller = TaskController.new

    def self.show_task(task)
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
      task = param ? controller.show(param) : controller.index
      if param.nil?
        task = controller.index
      elsif param.to_i.to_s == param
        task = controller.show(param)
      else
        task = controller.search_by_status(param)
      end
      if task
        show_task(task)
      else
        puts "Task não encontrada!"
      end

    when ''

    when 'delete'
      controller.destroy(param)
      puts "Deletar task #{param}"

    when 'update'
      controller.update(param, ARGV[2])

    when 'mark-in-progress'
      controller.mark_in_progress(param)

    when 'mark-done'
      controller.mark_done(param)
    else
      puts "Invalido"
    end

  end
end

