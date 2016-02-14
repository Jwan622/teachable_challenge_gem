require 'spec_helper'

describe "configuration module" do
  let(:extended_class) { Class.new { extend Configuration } }

  describe "#define_setting" do
    it "can initialize with default settings" do
      extended_class.define_setting(:email)
      extended_class.define_setting(:access_token)

      expect(extended_class.email).to eq(nil)
      expect(extended_class.access_token).to eq(nil)
    end

    it "can define the classes own settings" do
      extended_class.define_setting(:email, "some email")
      extended_class.define_setting(:access_token, "some random token")

      expect(extended_class.email).to eq("some email")
      expect(extended_class.access_token).to eq("some random token")
    end
  end

  describe "#configuration" do
    it "a user can configure his/her own variables in a configuration block" do
      extended_class.define_setting(:access_token)
      extended_class.define_setting(:email)

      extended_class.configuration do |config|
        config.access_token = "some token"
        config.email = "some email"
      end

      expect(extended_class.access_token).to eq("some token")
      expect(extended_class.email).to eq("some email")
    end
  end
end
