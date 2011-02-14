# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Corpora::Application.initialize!
#ActiveRecord::Base.connection.execute "SET collation_connection = 'utf8_bin'"