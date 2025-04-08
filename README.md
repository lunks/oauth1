[![Build Status](https://travis-ci.org/lunks/oauth1.svg?branch=master)](https://travis-ci.org/lunks/oauth1)
[![Dependency Status](https://gemnasium.com/lunks/oauth1.svg)](https://gemnasium.com/lunks/oauth1)
[![Code Climate](https://codeclimate.com/github/lunks/oauth1/badges/gpa.svg)](https://codeclimate.com/github/lunks/oauth1)

# OAuth1

Simple helper that helps you build the url needed to authenticate into a service using OAuth 1.0.

## Installation

Add this line to your application's Gemfile:

    gem 'oauth1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth1

## Usage

    # Setup data
    method = :get
    domain_url = 'http://some.app.com/auth/'
    user_data = { uid: user_email + encrypted_password }
    oauth_config = { consumer_key: ENV['OAUTH_KEY'], consumer_secret: ENV['OAUTH_SECRET'] }

    # Usage
    oauth = Oauth::Helper.new(method, domain_url, user_data, oauth_config)

    # Returns
    oauth.signature_base # Returns the signature appended in the auth url
    oauth.full_url       # The proper url used for authentication


After that, all you need to do is to redirect the user to `oauth.full_url`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
