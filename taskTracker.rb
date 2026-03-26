require_relative "lib/Db/setupDatabase"
require_relative "lib/View/taskView"

setup_tables()

TaskView.run(ARGV)