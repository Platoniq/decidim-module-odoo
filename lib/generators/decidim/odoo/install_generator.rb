# frozen_string_literal: true

require "rails/generators/base"

module Decidim
  module Odoo
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "This generator modifies secrets file adding odoo to omniauth methods"
        def secrets
          case Rails.env
          when "development"
            inject_into_file "development_app/config/secrets.yml", after: "icon: phone" do
              <<~YAML
                |
                |    odoo_keycloak:
                |      enabled: true
                |      icon_path: media/images/odoo_logo.svg
              YAML
                .gsub(/^ *\|/, "").rstrip
            end
          when "test"
            inject_into_file "spec/decidim_dummy_app/config/secrets.yml", after: "app_secret: fake-facebook-app-secret" do
              <<~YAML
                |
                |    odoo_keycloak:
                |      enabled: false
                |      icon_path: media/images/odoo_logo.svg
              YAML
                .gsub(/^ *\|/, "").rstrip
            end
          end
        end

        desc "This generator copies the initializer file"
        def initializers
          Dir.chdir(Rails.env.test? ? "spec/decidim_dummy_app" : "development_app") do
            FileUtils.cp(
              "#{__dir__}/templates/#{Rails.env}_odoo_config.rb",
              "config/initializers/odoo_config.rb"
            )
          end
        end
      end
    end
  end
end
