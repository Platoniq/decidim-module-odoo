# frozen_string_literal: true

module Decidim
  module Odoo
    module Api
      module Base
        class BaseQuery
          attr_reader :result, :request

          def response
            @request.response
          end

          protected

          def parsed_response
            raise NotImplementedError
          end

          def store_result
            @result = parsed_response
            @result = @result.deep_symbolize_keys if @result.is_a? Hash
          end
        end
      end
    end
  end
end
