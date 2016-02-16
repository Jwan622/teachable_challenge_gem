require './lib/teachable/stats'

module Teachable
  module Stats
    def self.get_orders
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/api/orders.json"
        header = { accept: :json }
        response = RestClient.get base_url,
                                  params: {
                                      user_email: self.user_email,
                                      user_token: self.user_token
                                  }
        JSON.parse(response.body)
      rescue => e
        errors = JSON.parse(e.response)
        errors_formatted = errors["error"]
        "#{errors_formatted}"
      end
    end
  end
end
