require 'spec_helper'

describe Teachable::Stats do
  describe "VERSION constant" do
    it 'has a version number' do
      expect(Teachable::Stats::VERSION).not_to be nil
    end
  end
end
