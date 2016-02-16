require 'spec_helper'

describe "#authenticate" do
  before(:each) do
    logout
  end

  it "does not set your user_token and email with invalid credentials" do
    VCR.use_cassette("authenticate_does_not_set_token", record: :all) do
      invalid_email = "invalid_email1@example.com"
      invalid_password = "tooshor"

      response = Teachable::Stats.authenticate(email: invalid_email,
                                              password: invalid_password
                                              )

      expect(Teachable::Stats.user_email).to eq(nil)
      expect(Teachable::Stats.user_token).to eq(nil)
      expect(response).to eq("That username and password combination is incorrect. I think you need to register first.")
    end
  end

  it "sets your user_token and email" do
    VCR.use_cassette("authenticate_sets_token") do
      valid_email = "valid_email1@example.com"
      valid_password = "password"
      valid_token = "-y9s9TyMHdWmniBLfE8i"

      response = Teachable::Stats.authenticate(email: valid_email,
                                              password: valid_password
                                              )

      expect(Teachable::Stats.user_email).to eq("valid_email1@example.com")
      expect(Teachable::Stats.user_token).to eq("-y9s9TyMHdWmniBLfE8i")
      expect(response).to eq("Logged in as user: #{valid_email} with token: #{valid_token}")
    end
  end
end
