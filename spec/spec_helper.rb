require 'simplecov'
require 'pathname'
require_relative '../baseball_statistics'

APP_PATH = Pathname.new File.expand_path(File.join(File.dirname(__FILE__), '..'))
Dir[APP_PATH + "lib/baseball_statistics/" + "**" + "*.rb"].each { |files| require files }

SimpleCov.start