require "bundler/setup"
require "wetransfer"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc'
  config.order = :random
end


def fixtures_dir
  __dir__ + '/fixtures/'
end
