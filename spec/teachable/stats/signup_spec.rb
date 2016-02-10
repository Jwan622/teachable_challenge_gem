require './spec/spec_helper'

describe "signup" do
  it "signup class exists" do
    expect(Teachable::Stats::Signup).to be_truthy
  end
end
