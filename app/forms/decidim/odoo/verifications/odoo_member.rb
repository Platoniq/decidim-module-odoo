# frozen_string_literal: true

require "digest"

module Decidim
  module Odoo
    module Verifications
      class OdooMember < Decidim::AuthorizationHandler
        validate :user_valid

        def metadata
          super.merge(
            uid: uid,
            odoo_user_ref: odoo_user&.ref
          )
        end

        def unique_id
          Digest::SHA512.hexdigest("#{uid}-#{Rails.application.secrets.secret_key_base}")
        end

        protected

        def organization
          current_organization || user&.organization
        end

        def uid
          odoo_user&.odoo_user_id
        end

        def odoo_user
          @odoo_user ||= Decidim::Odoo::User.find_by(user: user)
        end

        def odoo_api_user
          @odoo_api_user ||= begin
            Decidim::Odoo::Api::FindPartner.new(uid).result
          rescue Decidim::Odoo::Error => _e
            nil
          end
        end

        def user_valid
          errors.add(:user, "decidim.odoo.errors.not_found") if odoo_user.blank? && odoo_api_user.blank?
          if (odoo_user && !odoo_user.odoo_member?) || (odoo_api_user && !odoo_api_user[:member] && !odoo_api_user[:coop_candidate])
            errors.add(:user, "decidim.odoo.errors.not_member")
          end
        end
      end
    end
  end
end
