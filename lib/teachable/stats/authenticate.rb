require './lib/teachable/stats'

module Teachable
  module Stats
    def self.authenticate(email:, password:)
      begin
        user_credentials = get_token(email: email, password: password)
        raise RegistrationError if failed_authentication?(user_credentials)
        self.user_email, self.user_token = user_credentials["email"], user_credentials["tokens"]
        "Logged in as user: #{self.user_email} with token: #{self.user_token}"
      rescue => e
        if e.class == RegistrationError
          "#{e.message}"
        else
          errors = JSON.parse(e.response)
          errors_formatted = errors["error"]
          "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
        end
      end
    end

    private

    def self.failed_authentication?(response)
      response =~ /Invalid email or password/
    end
  end
end
