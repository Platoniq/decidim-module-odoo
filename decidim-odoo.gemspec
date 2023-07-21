# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/odoo/version"

Gem::Specification.new do |s|
  s.version = Decidim::Odoo::VERSION
  s.authors = ["Francisco Bolívar"]
  s.email = ["francisco.bolivar@nazaries.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-odoo"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-odoo"
  s.summary = "A decidim odoo module"
  s.description = "A Decidim module to sync Odoo users who connect to the platform using Keycloak OpenID OAuth."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Odoo::COMPAT_DECIDIM_VERSION
  s.add_dependency "omniauth-keycloak", "~> 1.5"

  s.add_development_dependency "decidim-dev", Decidim::Odoo::COMPAT_DECIDIM_VERSION
end
