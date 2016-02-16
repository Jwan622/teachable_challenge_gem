require './lib/teachable/stats'

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
        if e.class == RestClient::Unauthorized
          errors = JSON.parse(e.response)
          errors_formatted = errors["error"]
          "Something went wrong when trying to get your user info and token. These are your errors: #{errors_formatted}"
        end
      end
    end
  end
end
