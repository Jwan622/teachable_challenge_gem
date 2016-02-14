require 'open-uri'
require 'rest-client'

module Teachable
  module Stats
    def self.get_token(email:, password:)
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/users/sign_in.json"
        header = { accept: :json }
        response = RestClient.post base_url,
                                    { "user": {
                                            "email": email,
                                            "password": password
                                            }
                                    },
                                    header
        JSON.parse(response.body)
      rescue => e
        errors = JSON.parse(e.response)
        errors_formatted = errors["error"]
        "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
      end
    end
  end
end
