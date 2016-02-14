require 'spec_helper'

describe "#authenticate" do
  it "sets your user_token and email" do
    VCR.use_cassette("authenticate_sets_token") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"
      valid_token = "-y9s9TyMHdWmniBLfE8i"

      response = Teachable::Stats.authenticate(email: valid_email,
                                    password: valid_password)

      expect(Teachable::Stats.user_email).to eq("valid_email1@example.com")
      expect(Teachable::Stats.user_token).to eq("-y9s9TyMHdWmniBLfE8i")
      expect(response).to eq("Logged in as user: #{valid_email} with token: #{valid_token}")
    end
  end
end
