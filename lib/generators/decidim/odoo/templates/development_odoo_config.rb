# frozen_string_literal: true

Decidim::Odoo.configure do |config|
  # Configure api credentials
  config.api = {
    base_url: ENV["ODOO_API_BASE_URL"].presence,
    api_key: ENV["ODOO_API_API_KEY"].presence
  }

  # Configure omniauth secrets
  config.keycloak_omniauth = {
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
