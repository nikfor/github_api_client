module API
  module Graphql
    class Base
      extend Dry::Initializer

      option :access_token, default: proc { Settings.api.github.token }

      def post(body, variables="")
        HTTParty.post(
          'https://api.github.com/graphql',
          headers: headers, 
          body: { 
            query:      body, 
            variables:  variables
          }.to_json
        )
      end

      private

      def headers
        { 'Authorization' => "Bearer #{access_token}",
          'User-Agent' => 'Httparty'
        }
      end
    end
  end
end