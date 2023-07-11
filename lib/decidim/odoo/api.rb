# frozen_string_literal: true

require_relative "api/base/base_query"
require_relative "api/base/request"
require_relative "api/find_partner_by_vat"

module Decidim
  module Odoo
    # This namespace holds the logic to connect to the CiViCRM REST API.
    module Api
      def self.config
        Decidim::Odoo.api
      end

      def self.api_key
        config[:api_key]
      end

      def self.base_url
        config[:base_url]
      end
    end
  end
end
