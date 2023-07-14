# frozen_string_literal: true

module Decidim
  module Odoo
    module UserOverride
      extend ActiveSupport::Concern

      included do
        has_one :odoo_user, class_name: "Decidim::Odoo::User", foreign_key: "decidim_user_id", dependent: :destroy

        def odoo_identity
          identities.find_by(provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME)
        end

        def odoo_identity?
          identities.exists?(provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME)
        end
      end
    end
  end
end
