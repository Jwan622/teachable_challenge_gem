require 'spec_helper'

describe "get user endpoint" do
  describe "#user_info" do
    it "cannot get the user without being authenticated first" do
      VCR.use_cassette("user_get_not_authenticated", :re_record_interval => 60 * 60 * 24 * 5) do
        expected_error = "Something went wrong when trying to get your user info. These are your errors: You need to sign in or sign up before continuing."

        logout
        response = Teachable::Stats.get_user

        expect(response).to eq(expected_error)
        expect(response["token"]).to be_falsey
      end
    end

    it "can get user info if you authenticate first" do
      VCR.use_cassette("user_get_authenticated", :re_record_interval => 60 * 60 * 24 * 5) do
        valid_email = "some_user_new6@gmail.com"
        valid_password = "password"

        logged_in_user = Teachable::Stats.authenticate(email: valid_email,
                                                      password: valid_password)
        valid_user_response = Teachable::Stats.get_user

        expect(valid_user_response["email"]).to eq(valid_email)
        expect(valid_user_response["tokens"]).to eq(logged_in_user[-20..-1])
      end
    end
  end
end
