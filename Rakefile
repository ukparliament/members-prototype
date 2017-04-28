# Check if rspec is available (handles production use)
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError => e
  Rails.logger.warn(e.message)
  # rspec is not available
end

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
