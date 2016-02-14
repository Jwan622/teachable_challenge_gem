require 'open-uri'
require 'rest-client'

module Teachable
  module Stats
    class User
      def self.get(email: , user_token:)
        begin
          base_url = "https://fast-bayou-75985.herokuapp.com/api/users/current_user/edit.json"
          response = RestClient.get base_url, params: { user_email: email,
                                                        user_token: user_token }
          JSON.parse(response.body)
        rescue => e
          errors = JSON.parse(e.response)
          errors_formatted = errors["error"]
          "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
        end
      end
    end
  end
end
