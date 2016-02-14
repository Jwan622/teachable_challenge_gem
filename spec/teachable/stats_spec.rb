require 'spec_helper'

describe "stats main" do
  describe "VERSION constant" do
    it 'has a version number' do
      expect(Teachable::Stats::VERSION).not_to be nil
    end
  end

  describe "default settings" do
    # reload the gem to get the defaults which are class variables which may have
    # been affected by the other tests.
    
    before(:each) do
      Object.send(:remove_const, "Teachable")
      load './lib/teachable/stats.rb'
    end

    it "sets your user_token and email to nil by default" do
      expect(Teachable::Stats.user_email).to eq(nil)
      expect(Teachable::Stats.user_token).to eq(nil)
    end
  end

end
