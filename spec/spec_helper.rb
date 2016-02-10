$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir["./lib/teachable/stats/*.rb"].each {|file| require file }
require 'teachable/stats'
require 'rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures"
  c.hook_into :webmock
end
