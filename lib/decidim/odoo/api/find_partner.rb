# frozen_string_literal: true

module Decidim
  module Odoo
    module Api
      class FindPartner < Base::BaseQuery
        def initialize(ref)
          @request = Base::Request.get("partner/#{ref}")

          store_result
        end

        protected

        def parsed_response
          response
        end
      end
    end
  end
end
