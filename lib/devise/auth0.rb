require "devise/auth0/version"
require 'devise/models/auth0_authenticatable'
require 'devise/strategies/auth0_authenticatable'

module Devise
  module Auth0
    CLIENT_ID = ENV.fetch 'AUTH0_CLIENT_ID'
    SECRET = Base64.decode64 ENV.fetch('AUTH0_SECRET').gsub('-', '+').gsub('_','/')
  end
end
