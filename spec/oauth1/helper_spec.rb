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
      expect(url_params.keys).not_to include('oauth_consumer_secret')
    end

    it 'does not have oauth_token as a param' do
      expect(url_params[:oauth_token]).to be_nil
    end

    it 'returns an array with the options and the params' do
      expect(url_params.keys.size).to eq(6)
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

    context 'with array parameters' do
      let(:array_params) { {user_specified_param: 'params', tags: ['ruby', 'rails']} }
      let(:array_helper) { OAuth1::Helper.new(:get, url, array_params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }
      let(:array_signature_base) { array_helper.signature_base }

      it 'handles array parameters correctly' do
        expect(array_signature_base).to include('tags%3Druby')
        expect(array_signature_base).to include('tags%3Drails')
      end

      it 'properly escapes each parameter only once' do
        expect(array_signature_base).to match(/tags%3Druby/)
        expect(array_signature_base).to match(/tags%3Drails/)
      end
    end

    context 'with parameters containing special characters' do
      let(:special_params) { {query: 'space test', tags: ['special!@#$']} }
      let(:special_helper) { OAuth1::Helper.new(:get, url, special_params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }
      let(:special_signature_base) { special_helper.signature_base }

      it 'properly escapes special characters' do
        expect(special_signature_base).to match(/query%3Dspace%2520test/)
      end

      it 'properly escapes special characters in array values' do
        expect(special_signature_base).to match(/tags%3Dspecial%2521%2540%2523%2524/)
      end
    end

    context 'with array parameter keys containing brackets' do
      let(:bracket_params) { {'tags[]' => ['ruby', 'rails']} }
      let(:bracket_helper) { OAuth1::Helper.new(:get, url, bracket_params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }
      let(:bracket_signature_base) { bracket_helper.signature_base }

      it 'escapes the brackets in parameter keys' do
        expect(bracket_signature_base).to match(/tags%255B%255D%3Druby/)
        expect(bracket_signature_base).to match(/tags%255B%255D%3Drails/)
      end

      it 'consistently encodes the brackets' do
        expect(bracket_signature_base).to match(/tags%255B%255D/)
        expect(bracket_signature_base.scan(/tags%255B%255D/).count).to eq(2)
      end
    end
  end

  describe '#full_url' do
    let(:full_url) { helper.full_url }

    it { expect(full_url).to match(/oauth_consumer_key=#{consumer_key}/) }
    it { expect(full_url).to match(/oauth_signature_method=HMAC-SHA1/) }
    it { expect(full_url).to match(/oauth_signature=/) }
    it { expect(full_url).to match(/user_specified_param/) }

    context 'with array parameters' do
      let(:array_params) { {tags: ['ruby', 'rails']} }
      let(:array_helper) { OAuth1::Helper.new(:get, url, array_params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }
      let(:array_full_url) { array_helper.full_url }

      it 'includes all array values in the URL' do
        expect(array_full_url).to include('tags=ruby')
        expect(array_full_url).to include('tags=rails')
      end
    end

    context 'with array parameter keys containing brackets' do
      let(:bracket_params) { {'tags[]' => ['ruby', 'rails']} }
      let(:bracket_helper) { OAuth1::Helper.new(:get, url, bracket_params, {consumer_key: consumer_key, consumer_secret: consumer_secret}) }
      let(:bracket_full_url) { bracket_helper.full_url }

      it 'properly includes brackets in the URL' do
        expect(bracket_full_url).to include('tags%5B%5D=ruby')
        expect(bracket_full_url).to include('tags%5B%5D=rails')
      end
    end
  end
end
