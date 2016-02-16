$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir["./lib/teachable/stats/*.rb"].each {|file| require file }
require 'teachable/stats'
require 'rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures"
  c.hook_into :webmock
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
