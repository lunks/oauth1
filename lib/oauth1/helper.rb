require 'active_support/core_ext/hash/reverse_merge'
require 'addressable/uri'
require 'cgi'
require 'base64'
require 'openssl'
require 'securerandom'

module OAuth1
  class Helper
    attr_reader :url_params

    def initialize(method, url, params, options)
      options.reverse_update({
        version: "1.0",
        signature_method: options.delete(:sign_method),
        timestamp: Time.now.to_i.to_s,
        nonce: SecureRandom.uuid
      })

      @consumer_secret = options.delete(:consumer_secret)
      @token_secret = options.delete(:token_secret)
      @url_params = params.merge(prepend_oauth_to_key(options))
      @method = method.to_s.upcase
      @url = Addressable::URI.parse(url)
    end

    def signature_base
      @url_params.delete(:oauth_signature)
      [@method, @url.to_s, url_with_params.query].map{|v| CGI.escape(v) }.join('&')
    end


    def full_url(sign_method)
      append_signature_to_params(sign_method)
      url_with_params.to_s
    end

    private
      def key
        @token_secret ? "#{CGI.escape(@consumer_secret)}&#{CGI.escape(@token_secret)}" : "#{CGI.escape(@consumer_secret)}&"
      end

      def url_with_params
        @url.dup.tap{|url| url.query_values = url_params}
      end

      def append_signature_to_params(sign_method)
        @url_params[:oauth_signature] = hmac_signature(key, signature_base, sign_method)
      end

      def prepend_oauth_to_key(options)
        Hash[options.map{|key, value| ["oauth_#{key}".to_sym, value]}]
      end

      def hmac_signature(key, signature_string, sign_method)
        digest = OpenSSL::Digest.new(sign_method)
        hmac = OpenSSL::HMAC.digest(digest, key, signature_string)
        Base64.encode64(hmac).chomp.gsub(/\n/, '')
      end
  end
end
