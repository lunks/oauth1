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

    oauth = Oauth::Helper.new(method, domain_url, user_data, oauth_config)

    oauth.signature_base # Returns the signature appended in the auth url
    oauth.full_url       # The proper url used for authentication

`method` refers to the http method used. Most commonly `:get`.

`domain_url` is the base url for the domain that you will authenticate. For example _http://myawesomeapp.com/auth/_

`user_date` is a hash with the user _uid_. For example `{ uid: user_email + encrypted_password }`

`oauth_config` is a hash with the oauth consumer key and secret: `{ consumer_key: ENV['OAUTH_KEY'], consumer_secret: ENV['OAUTH_SECRET'] }`



After that, all you need to do is to redirect the user to `oauth.full_url`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Mantainers

 - [Israel Ribeiro](https://github.com/israveri)