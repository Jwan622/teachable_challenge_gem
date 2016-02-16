require './spec/spec_helper'

describe "#register" do
  it "registers successfully with a valid username and password" do
    VCR.use_cassette("valid registration", :re_record_interval => 60 * 60 * 24 * 5) do
      response_valid = Teachable::Stats.register(email: "original_email6@gmail.com",
                                                        password: "password",
                                                        password_confirmation: "password")

      expect(response_valid["id"]).to eql(39)
      expect(response_valid["name"]).to eql(nil)
      expect(response_valid["nickname"]).to eql(nil)
      expect(response_valid["image"]).to eql(nil)
      expect(response_valid["email"]).to eql("original_email6@gmail.com")
      expect(response_valid["tokens"]).to be_truthy
    end
  end

  it "registers unsuccessfully with a password that is too short" do
    VCR.use_cassette("too short password", :re_record_interval => 60 * 60 * 24 * 7) do
      password_too_short_error_message = "Something went wrong when trying to register. These are your errors: password is too short (minimum is 8 characters)"

      response_too_short = Teachable::Stats.register(email: "original_email7@gmail.com",
                                                            password: "too",
                                                            password_confirmation: "too")

      expect(response_too_short).to eql(password_too_short_error_message)
    end
  end

  it "registers unsuccessfully with a duplicate email" do
    VCR.use_cassette("duplicate email", :re_record_interval => 60 * 60 * 24 * 7) do
      duplicate_email_error_message = "Something went wrong when trying to register. These are your errors: email has already been taken"

      Teachable::Stats.register(email: "some_email8@gmail.com",
                                        password: "password",
                                        password_confirmation: "password")
      response_duplicate = Teachable::Stats.register(email: "some_email8@gmail.com",
                                                            password: "password",
                                                            password_confirmation: "password")

      expect(response_duplicate).to eql(duplicate_email_error_message)
    end
  end


  it "responds with two errors if you try to register an existing email and your password doesn't match" do
    VCR.use_cassette("two errors") do
      error_message = "Something went wrong when trying to register. These are your errors: email has already been taken, password_confirmation doesn't match Password"

      Teachable::Stats.register(email: "original_email9@gmail.com",
                                        password: "password",
                                        password_confirmation: "password")
      response = Teachable::Stats.register(email: "original_email9@gmail.com",
                                                  password: "password",
                                                  password_confirmation: "non matching password")

      expect(response).to eql(error_message)
    end
  end
end
