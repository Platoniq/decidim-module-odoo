# frozen_string_literal: true

module Decidim
  module Odoo
    class User < ApplicationRecord
      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: "decidim_organization_id"
      belongs_to :user, class_name: "Decidim::User", foreign_key: "decidim_user_id"

      validates :user, uniqueness: true
      validates :odoo_user_id, uniqueness: { scope: :organization }
      validates :ref, uniqueness: { scope: :organization }

      def odoo_member?
        member || coop_candidate
      end
    end
  end
end
