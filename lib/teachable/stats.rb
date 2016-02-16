require "teachable/stats/version"
require "helpers/configuration"
require 'open-uri'
require 'rest-client'
Dir["./lib/teachable/stats/*.rb"].each {|file| require file }

module Teachable
  module Stats
    extend Configuration

    define_setting :user_email
    define_setting :user_token
  end
end
