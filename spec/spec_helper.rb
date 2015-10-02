$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'worse_model'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Add chained matcher to description
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
