require 'bundler'
require 'tty-prompt'
#config.active_record.logger = nil

#require 'tty-table'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'lib'

$prompt = TTY::Prompt.new