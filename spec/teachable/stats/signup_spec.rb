require './spec/spec_helper'

describe "signup" do
  it "signup class exists" do
    expect(Teachable::Stats::Signup).to be_truthy
  end

  it "registers successfully with a valid username and password" do
    {"id"=>18,
     "name"=>nil,
     "nickname"=>nil,
     "image"=>nil,
     "email"=>"first_email1@gmail.com",
     "tokens"=>"vABqBnTqpMynRzbhCQLQ",
     "created_at"=>"2016-02-11T20:55:21.266Z",
     "updated_at"=>"2016-02-11T20:55:21.282Z"}
  end

  it "registers unsuccessfully with a password that is too short" do
    VCR.use_cassette("too short password", :re_record_interval => 60 * 60 * 24 * 7) do
      password_too_short_error_message = "Something went wrong when trying to register. These are your errors: password is too short (minimum is 8 characters)"

      response_too_short = Teachable::Stats::Signup.new.register("some_email1@gmail.com", "too", "too")

      expect(response_too_short).to eql(password_too_short_error_message)
    end
  end

  it "registers unsuccessfully with a duplicate email" do
    VCR.use_cassette("duplicate email", :re_record_interval => 60 * 60 * 24 * 7) do
      duplicate_email_error_message = "Something went wrong when trying to register. These are your errors: email has already been taken"

      Teachable::Stats::Signup.new.register("some_email5@gmail.com", "password", "password")
      response_duplicate = Teachable::Stats::Signup.new.register("some_email5@gmail.com", "password", "password")

      expect(response_duplicate).to eql(duplicate_email_error_message)
    end
  end


  it "responds with two errors if you try to register an existing email and your password doesn't match" do
    VCR.use_cassette("two errors") do
      error_message = "Something went wrong when trying to register. These are your errors: email has already been taken, password_confirmation doesn't match Password"

      Teachable::Stats::Signup.new.register("first_email2@gmail.com", "password", "password")
      response = Teachable::Stats::Signup.new.register("first_email2@gmail.com", "password", "non matching password")

      expect(response).to eql(error_message)
    end
  end
end
