require 'sqlite3'

FILE_DATABASE = File.join(__dir__, "../Data/dtbTask.db")

def open_db
  db = SQLite3::Database.new FILE_DATABASE
  db
end


def setup_tables
  db = open_db
  db.execute <<-SQL
    create table if not exists tasks(
      id integer unique primary key not null,
      description text not null,
      status integer not null,
      created_at date not null,
      updated_at date
    );
  SQL
end