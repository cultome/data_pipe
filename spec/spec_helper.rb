require 'simplecov'
SimpleCov.start do
  add_filter do |src|
    src.filename.end_with? "_spec.rb"
  end
end

require "bundler/setup"
require "data_pipe"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

include DataPipe
include DataPipe::Error
