# frozen_string_literal: true

Decidim::Oddoo.configure do |config|
  # Configure api credentials
  config.api = {
    base_url: ENV["ODDOO_API_BASE_URL"].presence,
    api_key: ENV["ODDOO_API_API_KEY"].presence
  }

  # Configure omniauth secrets
  config.keycloak_omniauth = {
    enabled: ENV["OMNIAUTH_ODDOO_KEYCLOAK_CLIENT_ID"].present?,
    client_id: ENV["OMNIAUTH_ODDOO_KEYCLOAK_CLIENT_ID"].presence,
    client_secret: ENV["OMNIAUTH_ODDOO_KEYCLOAK_CLIENT_SECRET"].presence,
    client_options: {
      site: ENV["OMNIAUTH_ODDOO_KEYCLOAK_SITE"].presence,
      realm: ENV["OMNIAUTH_ODDOO_KEYCLOAK_REALM"].presence
    },
    icon_path: ENV["OMNIAUTH_ODDOO_KEYCLOAK_ICON_PATH"].presence || "media/images/oddoo_logo.svg"
  }
end
