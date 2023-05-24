# frozen_string_literal: true

require "decidim/oddoo/api"
require "decidim/oddoo/engine"

module Decidim
  # This namespace holds the logic of the `Oddoo` component. This component
  # allows users to create oddoo in a participatory space.
  module Oddoo
    include ActiveSupport::Configurable

    config_accessor :api do
      {
        base_url: ENV["ODDOO_API_BASE_URL"].presence,
        api_key: ENV["ODDOO_API_API_KEY"].presence
      }
    end

    config_accessor :omniauth do
      {
        enabled: ENV["OMNIAUTH_ODDOO_CLIENT_ID"].present?,
        client_id: ENV["OMNIAUTH_ODDOO_CLIENT_ID"].presence,
        client_secret: ENV["OMNIAUTH_ODDOO_CLIENT_SECRET"].presence,
        client_options: {
          site: ENV["OMNIAUTH_ODDOO_SITE"].presence,
          realm: ENV["OMNIAUTH_ODDOO_REALM"].presence
        },
        icon_path: ENV["OMNIAUTH_ODDOO_ICON_PATH"].presence || "media/images/oddoo_logo.svg"
      }
    end

    class Error < StandardError; end
  end
end
