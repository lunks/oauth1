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
        signature_method: 'HMAC-SHA1',
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

      # Convert parameters to array of [key, value] pairs
      pairs = @url_params.flat_map do |key, value|
        if value.is_a?(Array)
          # For arrays, create multiple pairs with the same key
          value.map { |v| [key.to_s, v.to_s] }
        else
          [[key.to_s, value.to_s]]
        end
      end

      # Sort first by key, then by value
      normalized_params = pairs.sort.map { |k, v| "#{escape(k)}=#{escape(v)}" }.join('&')

      # Create base string
      [@method, escape(@url.to_s), escape(normalized_params)].join('&')
    end

    # Use a single consistent escaping method
    def escape(value)
      CGI.escape(value.to_s).gsub('+', '%20')
    end

    def full_url
      append_signature_to_params
      url_with_params.to_s
    end

    private
      def key
        @token_secret ? "#{CGI.escape(@consumer_secret)}&#{CGI.escape(@token_secret)}" : "#{CGI.escape(@consumer_secret)}&"
      end

      def url_with_params
        @url.dup.tap{|url| url.query_values = url_params}
      end

      def append_signature_to_params
        @url_params[:oauth_signature] = hmac_sha1_signature(key, signature_base)
      end

      def prepend_oauth_to_key(options)
        Hash[options.map{|key, value| ["oauth_#{key}".to_sym, value]}]
      end

      def hmac_sha1_signature(key, signature_string)
        digest = OpenSSL::Digest.new('sha1')
        hmac = OpenSSL::HMAC.digest(digest, key, signature_string)
        Base64.encode64(hmac).chomp.gsub(/\n/, '')
      end
  end
end
