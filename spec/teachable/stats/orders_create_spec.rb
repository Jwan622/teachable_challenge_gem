require './spec/spec_helper'

describe "#create_order" do
  it "cannot create an order without a total" do
    VCR.use_cassette("order_missing_total", :re_record_interval => 60 * 60 * 24 * 5) do
      invalid_order_call = Proc.new { Teachable::Stats.create_order(number: 1,
                                              total_quantity: 3,
                                              email: "jwan622@gmail.com"
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: total")
    end
  end

  it "cannot create an order without a total quantity" do
    VCR.use_cassette("order_missing_total_quantity", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_order_call = Proc.new { Teachable::Stats.create_order(number: 1,
                                              total: 2,
                                              email: "jwan622@gmail.com"
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: total_quantity")
    end
  end

  it "cannot create an order without an email" do
    VCR.use_cassette("order_missing_email", :re_record_interval => 60 * 60 * 24 * 7) do
      invalid_order_call = Proc.new { Teachable::Stats.create_order(number: 1,
                                              total: 2,
                                              total_quantity: 3
                                              ) }

      expect { invalid_order_call.call }.to raise_error(ArgumentError, "missing keyword: email")
    end
  end


  it "creates one order by default if you don't supply a number" do
    VCR.use_cassette("order_missing_number", record: :all) do
      valid_order_call = Proc.new { Teachable::Stats.create_order(number: 1,
                                              total: 2,
                                              total_quantity: 3,
                                              email: "valid_email1@example.com"
                                              ) }

      expect { valid_order_call.call }.to_not raise_error
    end
  end

  xit "returns an array of orders" do
    VCR.use_cassette("order_returns_array_orders", :re_record_interval => 60 * 60 * 24 * 7) do

    end
  end

  xit "returns an unauthorized page message if the email is invalid" do
    expect(response).to eq("You are not authorized to access this page.")
  end
end
