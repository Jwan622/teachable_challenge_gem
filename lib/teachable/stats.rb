require "teachable/stats/version"
require "helpers/configuration"
require 'open-uri'
require 'rest-client'

module Teachable
  module Stats
    extend Configuration

    define_setting :user_email
    define_setting :user_token
  end
end
