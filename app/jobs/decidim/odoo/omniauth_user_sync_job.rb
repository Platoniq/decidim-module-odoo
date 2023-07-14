# frozen_string_literal: true

module Decidim
  module Odoo
    class OmniauthUserSyncJob < ApplicationJob
      queue_as :default

      def perform(data)
        user = Decidim::User.find(data[:user_id])
        return unless user.odoo_identity?

        Decidim::Odoo::SyncUser.call(user) do
          on(:ok) do |odoo_user|
            Rails.logger.info "OmniauthUserSyncJob: Success: Odoo user #{odoo_user.id} created for user #{odoo_user.user&.id}"
          end

          on(:invalid) do |message|
            Rails.logger.error "OmniauthUserSyncJob: ERROR: Odoo user creation error #{message}"
          end
        end
      end
    end
  end
end
