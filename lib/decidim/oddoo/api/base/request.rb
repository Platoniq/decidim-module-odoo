# frozen_string_literal: true

module Decidim
  module Oddoo
    module Api
      module Base
        class Request
          def initialize(verify_ssl: true)
            @verify_ssl = verify_ssl
          end

          attr_accessor :response, :body

          %w(get post).each do |method|
            define_singleton_method(method) do |path, params: {}, headers: {}, verify_ssl: true|
              instance = Request.new(verify_ssl: verify_ssl)
              response = instance.connection.public_send(method, instance.url(path)) do |request|
                request.params = instance.base_params.merge(params)
                request.headers = instance.base_headers.merge(headers)
              end

              raise Decidim::Oddoo::Error, response.reason_phrase unless response.success?

              instance.response = JSON.parse(response.body)
              instance
            end
          end

          def connection
            @connection ||= Faraday.new(ssl: { verify: @verify_ssl })
          end

          def url(path)
            "#{Decidim::Oddoo::Api.base_url}/#{path}"
          end

          def base_params
            {}
          end

          def base_headers
            { "api-key" => Decidim::Oddoo::Api.api_key }
          end
        end
      end
    end
  end
end
