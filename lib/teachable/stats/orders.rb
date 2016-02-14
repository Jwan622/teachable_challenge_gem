require './lib/teachable/stats'

module Teachable
  module Stats
    def self.get_orders(email:, user_token:)
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/api/orders.json"
        header = { accept: :json }
        response = RestClient.get base_url,
                                  params: {
                                      user_email: email,
                                      user_token: user_token
                                  }
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