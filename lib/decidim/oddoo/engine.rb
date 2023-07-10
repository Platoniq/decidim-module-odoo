# frozen_string_literal: true

require "omniauth/strategies/oddoo_keycloak"

module Decidim
  module Oddoo
    # This is the engine that runs on the public interface of oddoo.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Oddoo

      initializer "decidim_oddoo.omniauth" do
        next unless Decidim::Oddoo.keycloak_omniauth && Decidim::Oddoo.keycloak_omniauth[:client_id]

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :oddoo_keycloak, Decidim::Oddoo.keycloak_omniauth[:client_id], Decidim::Oddoo.keycloak_omniauth[:client_secret],
                   client_options: Decidim::Oddoo.keycloak_omniauth[:client_options]
        end
      end

      initializer "decidim_oddoo.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
