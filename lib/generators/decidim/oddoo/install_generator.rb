# frozen_string_literal: true

require "rails/generators/base"

module Decidim
  module Oddoo
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "This generator modifies secrets file adding oddoo to omniauth methods"
        def secrets
          case Rails.env
          when "development"
            inject_into_file "development_app/config/secrets.yml", after: "icon: phone" do
              <<~YAML
                |
                |    oddoo_keycloak:
                |      enabled: true
                |      icon_path: media/images/oddoo_logo.svg
              YAML
                .gsub(/^ *\|/, "").rstrip
            end
          when "test"
            inject_into_file "spec/decidim_dummy_app/config/secrets.yml", after: "app_secret: fake-facebook-app-secret" do
              <<~YAML
                |
                |    oddoo_keycloak:
                |      enabled: false
                |      icon_path: media/images/oddoo_logo.svg
              YAML
                .gsub(/^ *\|/, "").rstrip
            end
          end
        end

        desc "This generator copies the initializer file"
        def initializers
          Dir.chdir(Rails.env.test? ? "spec/decidim_dummy_app" : "development_app") do
            FileUtils.cp(
              "#{__dir__}/templates/#{Rails.env}_oddoo_config.rb",
              "config/initializers/oddoo_config.rb"
            )
          end
        end
      end
    end
  end
end
