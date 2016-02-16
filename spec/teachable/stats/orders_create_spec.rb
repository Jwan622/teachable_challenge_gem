require './spec/spec_helper'

describe "#create_my_order" do
  it "cannot create an order without a total" do
    VCR.use_cassette("order_create_missing_total", :re_record_interval => 60 * 60 * 24 * 5) do
      invalid_order_call = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                              total_quantity: 3,
                                              email: "jwan622@gmail.com"
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: total")
    end
  end

  it "cannot create an order without a total quantity" do
    VCR.use_cassette("order_missing_total_quantity", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_order_call = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                              total: 2,
                                              email: "jwan622@gmail.com"
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: total_quantity")
    end
  end

  it "cannot create an order without an email" do
    VCR.use_cassette("order_create_missing_email", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_order_call = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                              total: 2,
                                              total_quantity: 3
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: email")
    end
  end

  it "cannot create an order with an invalid email" do
    VCR.use_cassette("order_create_missing_email", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_order_call = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                              total: 2,
                                              total_quantity: 3,
                                              email: "this is not an email address"
                                              ) }
      require 'pry' ; binding.pry
      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: email")
    end
  end

  it "creates one order by default if you don't supply a number" do
    VCR.use_cassette("order_create_missing_number") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"

      Teachable::Stats.authenticate(email: valid_email, password: valid_password)
      valid_order_call = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                              total: 2,
                                              total_quantity: 3,
                                              email: valid_email
                                              ) }

      expect { @last_order = valid_order_call.call }.to_not raise_error

      Teachable::Stats.destroy_my_order(order_id: @last_order[0]["id"])

      expect { valid_order_call.call }.to change { Teachable::Stats.get_orders.count }.by(1)

      #teardown
      delete_all_orders_of_current_user
    end
  end

  it "cannot create an order unless authenticated" do
    VCR.use_cassette("order_create_unauthenticated") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"


      authenticated_order_create = Proc.new { Teachable::Stats.create_my_order(number: 1,
                                                                              total: 2,
                                                                              total_quantity: 3,
                                                                              email: valid_email
                                                                              ) }

      #find number of orders before an invalid call
      Teachable::Stats.authenticate(email: valid_email,
                                    password: valid_password
                                    )
      previous_order_count = Teachable::Stats.get_orders.count

      # Now that we have the previous order count, let's logout and try to create an order
      # remember logging out just means setting user_email and user_token to nil.
      logout
      expect(authenticated_order_create.call).to eq("You need to sign in or sign up before continuing.")

      # we need to login again to get the order count.
      Teachable::Stats.authenticate(email: valid_email,
                                    password: valid_password
                                    )
      expect(Teachable::Stats.get_orders.count).to eq(previous_order_count)
    end
  end

  it "creates multiple orders when supplied a number" do
    VCR.use_cassette("order_create_multiple") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"

      Teachable::Stats.authenticate(email: valid_email, password: valid_password)
      valid_three_orders = Teachable::Stats.create_my_order(number: 3,
                                                            total: 2,
                                                            total_quantity: 3,
                                                            email: valid_email
                                                            )
      expect(valid_three_orders.count).to eq(3)
      expect(valid_three_orders.all? { |order| order["email"] == valid_email }).to be true

      #teardown
      delete_all_orders_of_current_user
    end
  end
end
