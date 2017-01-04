require 'devise'
require 'devise/auth0/config'

module Devise
  module Strategies

    class Auth0Authenticatable < Base

      def self.config
        @config ||= Devise::Auth0::Config.new
      end

      def authenticate!
        token = env['HTTP_AUTHORIZATION'].to_s.gsub('Bearer ', '')

        begin
          decoded_token, header = JWT.decode(token, self.class.config.secret)
        rescue JWT::DecodeError
          Rails.logger.warn 'Unreadable Auth0 token'
          fail! 'Unreadable Auth0 token'
          return
        end

        if not decoded_token.is_a?(Hash)
          Rails.logger.warn "Unexpected Auth0 token structure: expected Hash, got #{decoded_token.inspect}"
          fail! "Unexpected Auth0 token structure: expected Hash, got #{decoded_token.inspect}"
          return
        end

        if decoded_token['aud'] == self.class.config.client_id
          user = mapping.to.find_or_sync_auth0(decoded_token)
          success! user
          return
        end

        Rails.logger.info "Invalid token"
        fail! 'Invalid token'
      end

      def store?
        false
      end

      def valid?
        env['HTTP_AUTHORIZATION'].present?
      end

    end

  end
end
