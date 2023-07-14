# frozen_string_literal: true

module Decidim
  module Odoo
    class SyncUser < Rectify::Command
      # Public: Initializes the command.
      #
      # user - A decidim user
      def initialize(user)
        @user = user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if we couldn't proceed.
      #
      # Returns nothing.
      def call
        update_user!
        create_user!

        ActiveSupport::Notifications.publish("decidim.odoo.user.updated", odoo_user.id)

        broadcast(:ok, odoo_user)
      rescue ActiveRecord::RecordNotUnique
        broadcast(:invalid, I18n.t("decidim.odoo.user.errors.not_unique"))
      rescue StandardError => e
        broadcast(:invalid, e.message)
      end

      private

      attr_reader :user, :odoo_user

      def create_user!
        @odoo_user = User.find_or_create_by(user: user, organization: user.organization)
        @odoo_user.odoo_user_id = odoo_info[:id]
        @odoo_user.ref = odoo_info[:ref]
        @odoo_user.coop_candidate = odoo_info[:coop_candidate]
        @odoo_user.member = odoo_info[:member]
        @odoo_user.save!
      end

      def update_user!
        user.nickname = odoo_info[:vat]
        user.name = odoo_info[:name]
        user.email = odoo_info[:email]
        user.save!
      end

      def odoo_info
        @odoo_info ||= ::Decidim::Odoo::Api::FindPartner.new(user.odoo_identity.uid).result
      end
    end
  end
end
