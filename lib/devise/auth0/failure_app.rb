module Devise
  module Auth0

    class FailureApp < Devise::FailureApp
      def respond
        if request.format == :json
          json_failure
        else
          super
        end
      end

      def json_failure
        self.status = 401
        self.content_type = 'application/json'
        self.response_body = { error: warden.message }.to_json
      end
    end

  end
end
