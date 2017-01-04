# Devise::Auth0

A devise/warden strategy for authenticating users with an Auth0-issued JSON web
token (JWT). This token is assumed to be provided via the Authorization HTTP
header.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-auth0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-auth0

## Configuration

In `config/initializers/devise.rb`:

``` ruby
require 'devise/strategies/auth0_authenticatable'

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  # this lets you use the login_as helper in tests
  config.skip_session_storage = [:auth0_authenticatable] unless Rails.env.test?

  config.warden do |manager|

    manager.strategies.add(:auth0_authenticatable, Devise::Strategies::Auth0Authenticatable) do
      config.client_id = "abc123"
      config.secret = "shhhh"
    end

    manager.default_strategies(scope: :user).unshift :auth0_authenticatable
  end
end
```
