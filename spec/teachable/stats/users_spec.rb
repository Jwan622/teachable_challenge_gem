require 'spec_helper'

describe "get user endpoint" do
  describe "#user_info" do
    it "has a user class" do
      expect(Teachable::Stats).to be_truthy
    end

    it "cannot get the user without the right password" do
      VCR.use_cassette("user_get_wrong_password", :re_record_interval => 60 * 60 * 24 * 5) do
        expected_error = "Something went wrong when trying to register. These are your errors: You need to sign in or sign up before continuing."
        valid_email = "original_email5@gmail.com"
        valid_password = "invalid_password"

        valid_credentials = Teachable::Stats.get_token(email: valid_email,
                                                            password: valid_password)

        response = Teachable::Stats.get_user(email: valid_credentials["email"],
                                            user_token: valid_credentials["tokens"])

        expect(response).to eq(expected_error)
        expect(response["token"]).to be_falsey
      end
    end

    it "can get user info if you provide the right email and token" do
      VCR.use_cassette("user_get_info", :re_record_interval => 60 * 60 * 24 * 5) do
        valid_email = "some_user_new6@gmail.com"
        valid_password = "password"

        valid_credentials = Teachable::Stats.get_token(email: valid_email,
                                                            password: valid_password)
        valid_user_response = Teachable::Stats.get_user(email: valid_credentials["email"],
                                                        user_token: valid_credentials["tokens"])

        expect(valid_user_response["email"]).to eq("some_user_new6@gmail.com")
        expect(valid_user_response["tokens"]).to eq("pD4y96BbgAJsPnnyzJgk")
      end
    end
  end
end
