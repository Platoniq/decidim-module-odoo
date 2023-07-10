# frozen_string_literal: true

Decidim::Oddoo.configure do |config|
  # Configure api credentials
  config.api = {
    base_url: "https://test.oddoo.api.example.org",
    api_key: "test-api-key"
  }

  # Configure omniauth secrets
  config.keycloak_omniauth = {
    enabled: true,
    client_id: "test-client-id",
    client_secret: "test-client-secret",
    client_options: {
      site: "https://test.oddoo.oauth.example.org",
      realm: "test-realm"
    }
  }
end
