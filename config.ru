require './app'
run Sinatra::Application
use ActiveRecord::ConnectionAdapters::ConnectionManagement
