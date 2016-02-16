require './lib/teachable/stats'

module Teachable
  module Stats
    def self.get_user(email: self.user_email, user_token: self.user_token)
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/api/users/current_user/edit.json"
        response = RestClient.get base_url, params: { user_email: email,
                                                      user_token: user_token }
        JSON.parse(response.body)
      rescue => e
        errors = JSON.parse(e.response)
        errors_formatted = errors["error"]
        "Something went wrong when trying to get your user info. These are your errors: #{errors_formatted}"
      end
    end
  end
end
