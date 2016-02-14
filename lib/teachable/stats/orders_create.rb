require './lib/teachable/stats'

module Teachable
  module Stats
    def self.create_order(number:, total:, total_quantity:, email:)
      begin
        base_url = "https://fast-bayou-75985.herokuapp.com/api/orders.json"
        header = { accept: :json }
        response_total_orders = []
        require 'pry' ; binding.pry
        number.times do
          response_total_orders = RestClient.post base_url,
                                  { params: { user_email: self.user_email,
                                              user_token: self.user_token
                                    },
                                    order: {
                                      total: total,
                                      total_quantity: total_quantity,
                                      email: email,
                                      special_instructions: "special instructions foo bar"
                                    }
                                  },
                                  header
        require 'pry' ; binding.pry
        end
        response_total_orders.map do |response|
          JSON.parse(response.body)
        end
      rescue => e

        errors = JSON.parse(e.response)
        errors_formatted = errors["error"]
        "Something went wrong when trying to register. These are your errors: #{errors_formatted}"
      end
    end
  end
end


=begin
invalid_arguments = order_create_invalid_args(number, total, total_quantity, email)
order_create_invalid_message = "These order create arguments are invalid: #{invalid_arguments}"
raise ArgumentError, order_create_invalid_message, unless order_params_valid?(number, total, total_quantity, email)

=end
