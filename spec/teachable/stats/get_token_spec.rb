require 'spec_helper'

describe "#get_token" do
  it "does not return back token with invalid email" do
    VCR.use_cassette("getting_token_with_nonregistered_user_email") do
      nonregistered_email = "nonregistered_email@gmail.com"
      valid_password = "password"
      expected_invalid_login_message = "Something went wrong when trying to get your user info and token. These are your errors: Invalid email or password."

      response_invalid = Teachable::Stats.get_token(email: nonregistered_email,
                                                    password: valid_password)

      expect(response_invalid).to eq(expected_invalid_login_message)
      expect(response_invalid["tokens"]).to be_falsey
    end
  end

  it "does not return back token with invalid password" do
    VCR.use_cassette("getting_token_with_invalid_user_password") do
      valid_email = "valid_email1@example.com"
      invalid_password = "invalid_password"
      expected_invalid_login_message = "Something went wrong when trying to get your user info and token. These are your errors: Invalid email or password."

      response_invalid = Teachable::Stats.get_token(email: valid_email,
                                                    password: invalid_password)

      expect(response_invalid).to eq(expected_invalid_login_message)
      expect(response_invalid["tokens"]).to be_falsey
    end
  end

  it "does return back a token from an existing user with valid email and password" do
    VCR.use_cassette("getting_token_with_valid_credentials") do
      existing_email = "valid_email1@example.com"
      valid_password = "password"

      response_valid_user = Teachable::Stats.get_token(email: existing_email,
                                                      password: valid_password)

      expect(response_valid_user["id"]).to be_truthy
      expect(response_valid_user["email"]).to eql(existing_email)
      expect(response_valid_user["tokens"]).to eql("-y9s9TyMHdWmniBLfE8i")
    end
  end
end
