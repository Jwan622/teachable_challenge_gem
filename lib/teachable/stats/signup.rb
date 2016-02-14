require 'open-uri'
require 'rest-client'

module Teachable
  module Stats
    class Signup
      def self.register(email: , password:, password_confirmation:)
        begin
          base_url = "https://fast-bayou-75985.herokuapp.com/users.json"
          header = { accept: :json }
          response = RestClient.post base_url,
                                    { "user" => { "email": email,
                                                  "password": password,
                                                  "password_confirmation": password_confirmation 
                                                }
                                    },
                                    header
          JSON.parse(response.body)
        rescue => e
          errors = JSON.parse(e.response)
          errors_formatted = errors["errors"].map do |error|
            error[0] + " " + error[1][0]
          end.join(", ")
          "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
        end
      end
    end
  end
end
