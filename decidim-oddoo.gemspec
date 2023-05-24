# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/oddoo/version"

Gem::Specification.new do |s|
  s.version = Decidim::Oddoo::VERSION
  s.authors = ["Francisco Bolívar"]
  s.email = ["francisco.bolivar@nazaries.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-oddoo"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-oddoo"
  s.summary = "A decidim oddoo module"
  s.description = "A Decidim module to sync Oddoo users who connect to the platform using Keycloak OpenID OAuth."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Oddoo::COMPAT_DECIDIM_VERSION
  s.add_dependency "omniauth-keycloak", "~> 1.5"

  s.add_development_dependency "decidim-dev", Decidim::Oddoo::COMPAT_DECIDIM_VERSION
end
