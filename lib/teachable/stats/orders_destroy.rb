require './lib/teachable/stats'

module Teachable
  module Stats
    def self.destroy_my_order(order_id: )
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/api/orders/#{order_id}.json"
        response = RestClient.delete base_url,
                                    params: { user_email: self.user_email,
                                              user_token: self.user_token
                                    }
        "Order with id: #{order_id} deleted." if response == ""
      rescue => e
        if e.class == RestClient::Unauthorized
          errors = JSON.parse(e.response)
          errors_formatted = errors["error"]
          "#{errors_formatted}"
        else
          errors = JSON.parse(e.response)
          errors_formatted = "That order_id does not exist" if errors["error"] == "Not Found"
          "Something went wrong when trying to delete that order. These are your errors: #{errors_formatted}"
        end
      end
    end
  end
end
