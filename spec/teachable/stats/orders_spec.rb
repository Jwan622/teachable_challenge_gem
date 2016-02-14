require 'spec_helper'

describe "orders" do
  describe "#get" do
    it "should return an empty array if no orders" do
      VCR.use_cassette("no_orders") do
        existing_email = "original_email5@gmail.com"
        valid_password = "password"

        valid_user = Teachable::Stats::User.get_token(email: existing_email,
                                                      password: valid_password)
        no_orders = Teachable::Stats::Orders.get(email: valid_user["email"],
                                                user_token: valid_user["tokens"])

        expect(no_orders).to eq([])
      end
    end

  end
end
