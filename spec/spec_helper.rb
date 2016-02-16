$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir["./lib/teachable/stats/*.rb"].each {|file| require file }
require 'teachable/stats'
require 'rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures"
  c.hook_into :webmock
end

class AuthenticationError < StandardError
  def initialize(msg="You need to call #authenticate first and pass in your email and password. For example: Teachable::Stats.authenticate(email: 'YourEmail@example.com', password: 'password')")
    super
  end
end

class RegistrationError < StandardError
  def initialize(msg="That username and password combination is incorrect. I think you need to register first.")
    super
  end
end

def delete_all_orders_of_current_user
  VCR.use_cassette("current_user_all_orders", record: :all) do
    raise AuthenticationError if Teachable::Stats.user_token == nil || Teachable::Stats.user_email == nil
    current_orders = Teachable::Stats.get_orders
    current_orders.each do |order|
      Teachable::Stats.destroy_my_order(order_id: order["id"])
    end
  end
end

def logout
  Teachable::Stats.user_email = nil
  Teachable::Stats.user_token = nil
end
