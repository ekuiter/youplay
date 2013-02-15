# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Youplay::Application.initialize!

ActiveRecord::Base.connection.execute 'SET collation_connection = "utf8_general_ci"'
ActiveRecord::Base.connection.execute 'SET collation_database = "utf8_general_ci"'
ActiveRecord::Base.connection.execute 'SET collation_server = "utf8_general_ci"'