# frozen_string_literal: true

module Decidim
  module Odoo
    module Admin
      class MembersController < Decidim::Admin::ApplicationController
        include Decidim::Paginable
        include Decidim::Odoo::Admin::Members::Filterable

        helper Decidim::HumanizeBooleansHelper
        helper Decidim::Messaging::ConversationHelper
        helper Decidim::Odoo::Admin::OdooHelper

        def index
          enforce_permission_to :read, :officialization
          @odoo_users = filtered_collection
        end

        def sync
          Decidim::Odoo::SyncUsersJob.perform_later(current_organization.id, params[:id])
          flash[:notice] = t("success", scope: "decidim.odoo.admin.members.sync")
          redirect_to decidim_odoo_admin.members_path
        end

        private

        def collection
          @collection ||= Decidim::Odoo::User.where(organization: current_organization).left_outer_joins(:user).order(updated_at: :desc)
        end
      end
    end
  end
end
