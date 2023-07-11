# frozen_string_literal: true

Decidim::Odoo.configure do |config|
  # Configure api credentials
  config.api = {
    base_url: "https://test.odoo.api.example.org",
    api_key: "test-api-key"
  }

  # Configure omniauth secrets
  config.keycloak_omniauth = {
    enabled: true,
    client_id: "test-client-id",
    client_secret: "test-client-secret",
    client_options: {
      site: "https://test.odoo.oauth.example.org",
      realm: "test-realm"
    }
  }
end
