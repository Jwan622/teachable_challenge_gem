require './lib/teachable/stats'

module Teachable
  module Stats
    def self.authenticate(email:, password:)
      begin
        response_with_token = get_token(email: email, password: password)
        self.user_email, self.user_token = response_with_token["email"], response_with_token["tokens"]
        "Logged in as user: #{self.user_email} with token: #{self.user_token}"
      rescue => e
        errors = JSON.parse(e.response)
        errors_formatted = errors["error"]
        "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
      end
    end
  end
end
