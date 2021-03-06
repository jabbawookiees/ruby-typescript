require 'rspec'

RSpec.configure do |config|
  config.color = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    @project_path = Pathname.new(File.expand_path('../../', __FILE__))
  end
end