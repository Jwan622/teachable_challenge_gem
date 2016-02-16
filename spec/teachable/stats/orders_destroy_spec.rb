require './spec/spec_helper'

describe "#destroy_order" do
  before(:each) do
    VCR.use_cassette("authentication", :re_record_interval => 60 * 60 * 24 * 5) do
      Teachable::Stats.authenticate(email: "valid_email1@example.com", password: "password")
    end
  end

  after(:each) do
    Teachable::Stats.user_email = nil
    Teachable::Stats.user_token = nil
  end

  it "cannot create an order without an order id" do
    VCR.use_cassette("order_destroy_missing_id", :re_record_interval => 60 * 60 * 24 * 5) do
      invalid_destroy_order_message = ""
      invalid_destroy_order_call = Proc.new { Teachable::Stats.destroy_my_order() }

      expect { invalid_destroy_order_call.call }.to raise_error(ArgumentError, "missing keyword: order_id")
    end
  end

  it "cannot destroy an order with a nonexistant id" do
    VCR.use_cassette("order_destroy_with_nonexistent_id", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_destroy_order_message = "Something went wrong when trying to delete that order. These are your errors: That order_id does not exist"
      invalid_destroy_order_call = Proc.new { Teachable::Stats.destroy_my_order(order_id: 1000000) }

      expect(invalid_destroy_order_call.call).to eq(invalid_destroy_order_message)
    end
  end

  it "cannot destroy an order unless authenticated" do
    VCR.use_cassette("order_destroy_unauthenticated") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"

      #lets create an order
      created_order = Teachable::Stats.create_my_order(number:1,
                                                      total:2,
                                                      total_quantity: 3,
                                                      email: "valid_email1@example.com").first
      logout
      response = Teachable::Stats.destroy_my_order(order_id: created_order["id"])
      expect(response).to eq("You need to sign in or sign up before continuing.")

      # let's see if that order is still there
      Teachable::Stats.authenticate(email: valid_email,
                                    password: valid_password)
      last_order = Teachable::Stats.get_orders.last

      expect(created_order).to eq(last_order)
    end
  end

  it "can destroy an order with an id" do
    VCR.use_cassette("order_destroy_with_id", :re_record_interval => 60 * 60 * 24 * 7) do
      valid_email = "valid_email1@example.com"
      valid_password = "password"
      get_orders_call = Proc.new { Teachable::Stats.get_orders}

      # let's check that deleting an order actually reduces the orders count by 1
      valid_order_1 = Teachable::Stats.create_my_order(number:1, total:2, total_quantity: 3, email: "valid_email1@example.com").first
      valid_destroy_order_call = Proc.new { Teachable::Stats.destroy_my_order(order_id: valid_order_1["id"]) }

      expect { valid_destroy_order_call.call }.to change{ get_orders_call.call.count }.by(-1)

      # lets check the error message when we delete an order
      valid_order_2 = Teachable::Stats.create_my_order(number:1, total:2, total_quantity: 3, email: "valid_email1@example.com").first
      valid_destroy_order_call_2 = Proc.new { Teachable::Stats.destroy_my_order(order_id: valid_order_2["id"]) }

      expect(valid_destroy_order_call_2.call).to eq("Order with id: #{valid_order_2["id"]} deleted.")

      #teardown
      delete_all_orders_of_current_user
    end
  end
end
