require 'spec_helper'

describe OAuth1::Helper do
  let(:url) { 'http://example.com' }
  let(:params) { {user_specified_param: 'params'} }
  let(:consumer_key) { 'some_key' }
  let(:consumer_secret) { 'some_secret' }

  let(:helper) { OAuth1::Helper.new(:get, url, params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }

  describe '#url_params' do
    let(:url_params) { helper.url_params }

    it 'prepends "oauth_" to option keys' do
      expect(url_params.keys).to include(:oauth_consumer_key)
    end

    it 'has some default options' do
      expect(url_params.keys).to include(:oauth_version)
    end

    it 'does not include the consumer_secret' do
      expect(url_params.keys).to_not include('oauth_consumer_secret')
    end

    it 'has oauth_token as an empty string' do
      expect(url_params[:oauth_token]).to be_empty
    end

    it 'returns an array with the options and the params' do
      expect(url_params.keys).to have(7).items
    end

    it 'has any user specified params' do
      expect(url_params.keys).to include(:user_specified_param)
    end
  end

  describe '#signature_base' do
    let(:signature_base) { helper.signature_base }

    it { expect(signature_base).to be_a(String) }

    it 'contains the http method' do
      expect(signature_base).to match(/GET/)
    end

    it 'contains the url' do
      expect(signature_base).to match(/example.com/)
    end

    it 'contains the params' do
      expect(signature_base).to match(/oauth_consumer_key/)
      expect(signature_base).to match(/user_specified_param/)
    end
  end

  describe '#full_url' do
    let(:full_url) { helper.full_url }

    it { expect(full_url).to match(/oauth_consumer_key=#{consumer_key}/) }
    it { expect(full_url).to match(/oauth_signature_method=HMAC-SHA1/) }
    it { expect(full_url).to match(/oauth_signature=/) }
    it { expect(full_url).to match(/user_specified_param/) }
  end
end
