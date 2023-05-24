# frozen_string_literal: true

require "omniauth-keycloak"

module OmniAuth
  module Strategies
    class Oddoo < OmniAuth::Strategies::KeycloakOpenId
      uid { oddoo_info[:ref] }

      info do
        {
          nickname: oddoo_info[:vat],
          name: oddoo_info[:name],
          email: oddoo_info[:email]
        }
      end

      def oddoo_info
        @oddoo_info ||= ::Decidim::Oddoo::Api::FindPartnerByVat.new(raw_info["preferred_username"]).result
      end
    end
  end
end
