require 'spec_helper'

describe OAuth1::Helper do
  let(:url) { "http://example.com" }
  let(:params) { {my_special_param: "params"} }
  let(:consumer_key) { "some_key" }
  let(:consumer_secret) { "some_secret" }

  let(:helper) { OAuth1::Helper.new(:get, url, params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }

  describe "#url_params" do
    let(:url_params) { helper.url_params }
    it "prepends oauth_ to option keys" do
      url_params.keys.should include(:oauth_consumer_key)
    end

    it "has some default options" do
      url_params.keys.should include(:oauth_version)
    end

    it "doesn't include the consumer_secret" do
      url_params.keys.should_not include("oauth_consumer_secret")
    end

    it "has oauth_token as an empty string" do
      url_params[:oauth_token].should eq(nil)
    end
  end

  describe "#url_params" do
    let(:url_params) { helper.url_params }
    it "returns an array with the options and the params" do
      url_params.should have(6).params
    end

    it "has the user-specified params" do
      url_params.keys.should include(:my_special_param)
    end
  end

  describe "#signature_base" do
    let(:signature_base) { helper.signature_base }
    it "returns an escaped string with method" do
      signature_base.should match(/GET/)
    end

    it "returns an escaped string with url" do
      signature_base.should match(/example.com/)
    end

    it "returns an escaped string with the params" do
      signature_base.should match(/oauth_consumer_key/)
      signature_base.should match(/my_special_param/)
    end
  end

  describe "#full_url" do
    let(:full_url) { helper.full_url }
    it "returns the url with the params for auth" do
      full_url.should match(/oauth_consumer_key=#{consumer_key}/)
      full_url.should match(/oauth_signature_method=HMAC-SHA1/)
      full_url.should match(/oauth_signature=/)
      full_url.should match(/my_special_param/)
    end
  end
end
