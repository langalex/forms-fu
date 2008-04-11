require 'rubygems'
gem 'actionpack'; gem 'activerecord'

require 'activerecord'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
