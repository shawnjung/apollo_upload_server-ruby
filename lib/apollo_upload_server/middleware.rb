require 'apollo_upload_server/graphql_data_builder'

module ApolloUploadServer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['CONTENT_TYPE'].to_s.include?('multipart/form-data')
        request = ActionDispatch::Request.new(env)
        if request.params['operations'].present? && request.params['map'].present?
          result = GraphQLDataBuilder.new.call(request.params)
          result.each do |key, value|
            request.request_parameters[key] = value
          end
        end
      end

      @app.call(env)
    end
  end
end
