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

      def authorize_params
        super.tap do |param|
          param[:kc_locale] = current_locale
        end
      end

      def query_string
        ""
      end

      private

      def current_locale
        request.params["locale"] || I18n.default_locale
      end
    end
  end
end
