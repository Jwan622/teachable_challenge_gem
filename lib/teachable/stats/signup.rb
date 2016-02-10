require 'open-uri'
require 'rest-client'

module Teachable
  module Stats
    class Signup
      def register
        begin
          base_url = "https://fast-bayou-75985.herokuapp.com/users.json"
          header = { content_type: :json, accept: :json }
          response = RestClient.post base_url, { "user" => { "email": "dev-25@example.com", "password": "password", "password_confirmation": "password" }}, header
          puts response
          puts JSON.parse(response.body)
        rescue => e
          e.response
        end
      end
    end
  end
end
