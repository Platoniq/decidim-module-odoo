# frozen_string_literal: true

require "omniauth-keycloak"

module OmniAuth
  module Strategies
    class OdooKeycloak < OmniAuth::Strategies::KeycloakOpenId
      option :name, "odoo_keycloak"

      uid { odoo_info[:ref] }

      info do
        {
          nickname: odoo_info[:vat],
          name: odoo_info[:name],
          email: odoo_info[:email]
        }
      end

      def odoo_info
        @odoo_info ||= ::Decidim::Odoo::Api::FindPartnerByVat.new(raw_info["preferred_username"]).result
      end
    end
  end
end
