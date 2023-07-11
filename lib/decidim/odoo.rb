# frozen_string_literal: true

require "decidim/odoo/api"
require "decidim/odoo/engine"

module Decidim
  # This namespace holds the logic of the `Odoo` component. This component
  # allows users to create odoo in a participatory space.
  module Odoo
    include ActiveSupport::Configurable

    config_accessor :api do
      {
        base_url: ENV["ODOO_API_BASE_URL"].presence,
        api_key: ENV["ODOO_API_API_KEY"].presence
      }
    end

    config_accessor :keycloak_omniauth do
      {
        enabled: ENV["OMNIAUTH_ODOO_KEYCLOAK_CLIENT_ID"].present?,
        client_id: ENV["OMNIAUTH_ODOO_KEYCLOAK_CLIENT_ID"].presence,
        client_secret: ENV["OMNIAUTH_ODOO_KEYCLOAK_CLIENT_SECRET"].presence,
        client_options: {
          site: ENV["OMNIAUTH_ODOO_KEYCLOAK_SITE"].presence,
          realm: ENV["OMNIAUTH_ODOO_KEYCLOAK_REALM"].presence
        },
        icon_path: ENV["OMNIAUTH_ODOO_KEYCLOAK_ICON_PATH"].presence || "media/images/odoo_logo.svg"
      }
    end

    class Error < StandardError; end
  end
end
