require_relative 'statusTask'
require_relative '../Db/setupDatabase'
require 'date'

class Task
  attr_accessor :id, :description, :status, :created_at, :updated_at

  def initialize(description)
    @description = description
    @status = StatusTask::STATUS_TASK[0]
    @created_at = (Date.today).to_s
  end

  def insert
    query = 'INSERT INTO tasks (description, status, created_at) VALUES (?, ?, ?)'
  
    db = open_db
    begin
      db.execute(query,  [@description, @status, @created_at])
      @id = db.last_insert_row_id
    ensure
      db.close if db
    end
    self
  end

  def self.all
    query = 'SELECT id, description, status, created_at, updated_at FROM tasks'
    result = []
    db = open_db
    begin
      db.execute(query) do |row|
        task = Task.new(row[1])
        task.id=row[0]
        task.status=row[2]
        task.created_at=row[3]
        task.updated_at=row[4]

        result << task
      end

    ensure
      db.close if db
    end
    result

  end

  def self.find(id)
    task = nil
    query = 'SELECT id, description, status, created_at, updated_at FROM tasks WHERE id = ?'
    db = open_db
    begin
      row = db.get_first_row(query, id)
      if row
        task = Task.new(row[1])
        task.id=row[0]
        task.status=row[2]
        task.created_at=row[3]
        task.updated_at=row[4]
      end
    ensure 
      db.close if db
    end
    task
  end

  def self.where(status)
    result = []
    query = 'SELECT id, description, status, created_at, updated_at FROM tasks WHERE status = ?'
    db = open_db

    begin
      db.execute(query, status) do |row|
        task = Task.new(row[1])
        task.id=row[0]
        task.status=row[2]
        task.created_at=row[3]
        task.updated_at=row[4]

        result << task
      end
    ensure
      db.close if db
    end
    result
  end

  def update
    @updated_at = (Date.today).to_s
    query = 'UPDATE tasks SET description = ?, status = ?, updated_at = ? WHERE id = ?'

    db = open_db
    begin
      db.execute(query, [@description, @status, @updated_at, @id])
    ensure
      db.close if db
    end
    self
  end


  def delete
    query = "DELETE FROM tasks WHERE id = ?"
    db = open_db
    begin
      db.execute(query, @id)
    ensure
      db.close if db
    end
    
  end
end