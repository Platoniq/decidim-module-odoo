# frozen_string_literal: true

module Decidim
  module Odoo
    module Api
      class FindPartnerByVat < Base::BaseQuery
        def initialize(vat)
          @request = Base::Request.get("partner", params: { vat: vat })

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
