require 'spec_helper'

describe "orders" do
  describe "#get" do

    it "should return an empty array if no orders" do
      VCR.use_cassette("get_orders_none") do
        new_email = "new_email_no_orders@gmail.com"
        valid_password = "password"

        Teachable::Stats.register(email: new_email,
                                  password: valid_password,
                                  password_confirmation: valid_password
                                  )
        Teachable::Stats.authenticate(email: new_email, password: valid_password)
        no_orders = Teachable::Stats.get_orders

        expect(no_orders).to eq([])
      end
    end

    it "should return all the orders created for a specific user" do
      VCR.use_cassette("get_orders_all", re_record_interval: 60 * 60 * 24 * 5) do
        new_email = "original_email10@example.com"
        valid_password = "password"

        Teachable::Stats.register(email: new_email,
                                  password: valid_password,
                                  password_confirmation: valid_password
        )
        Teachable::Stats.authenticate(email: new_email, password: valid_password)
        #making sure there are no orders to begin with
        delete_all_orders_of_current_user
        Teachable::Stats.create_my_order(number: 2,
                                        total: 3.0,
                                        total_quantity: 3,
                                        email: new_email
                                        )
        total_orders = Teachable::Stats.get_orders
        expect(total_orders.count).to eq(2)

        #teardown
        delete_all_orders_of_current_user
      end
    end
  end
end
