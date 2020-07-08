require 'apollo_upload_server/graphql_data_builder'

module ApolloUploadServer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      params = env['action_dispatch.request.request_parameters']

      if env['CONTENT_TYPE'].to_s.include?('multipart/form-data') && params['operations'].present? && params['map'].present?
        request = ActionDispatch::Request.new(env)
        result = GraphQLDataBuilder.new.call(request.params)
        result.each do |key, value|
          request.request_parameters[key] = value
        end
      end

      @app.call(env)
    end
  end
end
