require 'spec_helper'

describe "#get_token" do
  it "does not return back token with invalid email" do
    VCR.use_cassette("getting_token_with_invalid_user_email") do
      invalid_email = "invalid_email@gmail.com"
      valid_password = "password"
      expected_invalid_login_message = "Something went wrong when trying to register. These are your errors: Invalid email or password."

      response_invalid = Teachable::Stats.get_token(email: invalid_email,
                                                        password: valid_password)

      expect(response_invalid).to eq(expected_invalid_login_message)
      expect(response_invalid["tokens"]).to be_falsey
    end
  end

  it "does not return back token with invalid password" do
    VCR.use_cassette("getting_token_with_invalid_user_password") do
      valid_email = "original_email5@gmail.com"
      invalid_password = "invalid_password"
      expected_invalid_login_message = "Something went wrong when trying to register. These are your errors: Invalid email or password."

      response_invalid = Teachable::Stats.get_token(email: valid_email,
                                                    password: invalid_password)

      expect(response_invalid).to eq(expected_invalid_login_message)
      expect(response_invalid["tokens"]).to be_falsey
    end
  end

  it "does return back a token from a valid user" do
    VCR.use_cassette("getting_token_with_valid_credentials") do
      existing_email = "original_email5@gmail.com"
      valid_password = "password"

      response_valid = Teachable::Stats.get_token(email: existing_email,
                                                  password: valid_password)

      expect(response_valid["email"]).to eql(existing_email)
      expect(response_valid["tokens"]).to eql("2KaCu38HQXeeifirhm_z")
    end
  end



end
