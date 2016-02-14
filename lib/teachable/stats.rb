require "teachable/stats/version"
require "helpers/configuration"

module Teachable
  module Stats
    extend Configuration
    
    define_setting :user_email
    define_setting :user_token
  end
end
