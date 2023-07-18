# frozen_string_literal: true

module Decidim
  module Odoo
    class SyncUsersJob < ApplicationJob
      queue_as :default

      def perform(organization_id, odoo_user_id)
        odoo_users = Decidim::Odoo::User.where(decidim_organization_id: organization_id)
        odoo_users.where(id: odoo_user_id) if odoo_user_id
        Rails.logger.warn "SyncUsersJob: WARN: No results found for: organization_id='#{organization_id}' and odoo_user_id='#{odoo_user_id}'" if odoo_users.empty?

        odoo_users.each do |odoo_user|
          Decidim::Odoo::OmniauthUserSyncJob.perform_later(user_id: odoo_user.user.id)
        end
      end
    end
  end
end
