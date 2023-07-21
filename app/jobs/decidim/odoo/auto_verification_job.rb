# frozen_string_literal: true

module Decidim
  module Odoo
    class AutoVerificationJob < ApplicationJob
      queue_as :default

      def perform(odoo_user_id)
        @odoo_user = Decidim::Odoo::User.find(odoo_user_id)
        @odoo_user.odoo_member? ? create_auth : remove_auth
      rescue ActiveRecord::RecordNotFound => _e
        Rails.logger.error "AutoVerificationJob: ERROR: model not found for odoo user #{odoo_user_id}"
      end

      private

      def create_auth
        return unless (handler = Decidim::AuthorizationHandler.handler_for("odoo_member", user: @odoo_user.user))

        Decidim::Verifications::AuthorizeUser.call(handler, @odoo_user.organization) do
          on(:ok) do
            Rails.logger.info "AutoVerificationJob: Success: created for user #{handler.user.id}"
          end

          on(:invalid) do
            Rails.logger.error "AutoVerificationJob: ERROR: not created for user #{handler.user&.id}"
          end
        end
      end

      def remove_auth
        Decidim::Authorization.where(user: @odoo_user.user, name: "odoo_member").each do |auth|
          Decidim::Verifications::DestroyUserAuthorization.call(auth) do
            on(:ok) do
              Rails.logger.info "AutoVerificationJob: Success: removed for user #{auth.user.id}"
            end

            on(:invalid) do
              Rails.logger.error "AutoVerificationJob: ERROR: not removed for user #{auth.user&.id}"
            end
          end
        end
      end
    end
  end
end
