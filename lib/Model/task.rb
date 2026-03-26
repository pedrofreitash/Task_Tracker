require_relative 'statusTask'
require_relative '../Db/setupDatabase'
require 'date'

class Task
  attr_accessor :id, :description, :status, :created_at, :updated_at

  def initialize(id: nil, description:, status: nil, created_at: nil, updated_at: nil)
    @id = id
    @description = description
    @status = status || StatusTask::STATUS_TASK[:todo]
    @created_at = created_at || (Date.today).to_s
    @updated_at = updated_at

    @original_attributes = {
      description: @description,
      status: @status,
      updated_at: @updated_at
    }
  end

  def insert
    query = 'INSERT INTO tasks (description, status, created_at, updated_at) VALUES (?, ?, ?, ?)'
  
    db = open_db
    begin
      db.execute(query,  [@description, @status, @created_at, @updated_at])
      @id = db.last_insert_row_id
    ensure
      db.close if db
    end
    @original_attributes[:description] = @description
    @original_attributes[:status] = @status
    @original_attributes[:updated_atp] = @updated_at

    self
  end

  def self.all
    query = 'SELECT id, description, status, created_at, updated_at FROM tasks'
    result = []
    db = open_db
    begin
      db.execute(query) do |row|
        task = Task.new(id: row[0], description: row[1], status: row[2], created_at: row[3], updated_at: [4])
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
        task = Task.new(id: row[0], description: row[1], status: row[2], created_at: row[3], updated_at: [4])
      end
    ensure 
      db.close if db
    end
    task
  end

  def self.where(filters)
    
    conditions = []
    values = []
    
    result = []

    filters.each do |filter, value|
      conditions << "#{filter} = ?"
      values << value
    end


    query = "SELECT id, description, status, created_at, updated_at FROM tasks WHERE #{conditions.join(' AND')}"
    db = open_db

    begin
      db.execute(query, values) do |row|
        task = Task.new(id: row[0], description: row[1], status: row[2], created_at: row[3], updated_at: [4])

        result << task
      end
    ensure
      db.close if db
    end
    result
  end

  def update
    updates = []
    values = []

    fields = [:description, :status]

    fields.each do |field|
      current_value = instance_variable_get("@#{field}")
      original_attributes = @original_attributes[field]

      if current_value != original_attributes
        updates << "#{field} = ?"
        values << current_value
      end
    end

    return self if updates.empty?
    
    @updated_at = (Date.today).to_s
    updates << "updated_at = ?"
    values << @updated_at

    query = "UPDATE tasks SET #{updates.join(', ')} WHERE id = ?"
    values << @id

    db = open_db
    begin
      db.execute(query, values)
    ensure
      db.close if db
    end
    @original_attributes[:description] = @description
    @original_attributes[:status] = @status
    @original_attributes[:updated_atp] = @updated_at

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