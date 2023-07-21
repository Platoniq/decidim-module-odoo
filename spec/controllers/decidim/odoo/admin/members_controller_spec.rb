# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Odoo
    module Admin
      describe MembersController, type: :controller do
        routes { Decidim::Odoo::AdminEngine.routes }

        let(:organization) { create :organization }
        let(:user) { create(:user, :admin, :confirmed, organization: organization) }
        let(:odoo_users) { create_list(:odoo_user, 20, organization: organization) }

        before do
          request.env["decidim.current_organization"] = organization
          sign_in user, scope: :user
        end

        describe "#index" do
          it "renders the index template" do
            get :index

            expect(response).to render_template("decidim/odoo/admin/members/index")
          end
        end

        describe "#sync" do
          context "with id param" do
            it "enqueues one job" do
              expect { get :sync, params: { id: odoo_users.first.id } }.to have_enqueued_job(Decidim::Odoo::SyncUsersJob).with(organization.id, odoo_users.first.id.to_s)

              expect(response).to redirect_to("/admin/odoo/members")
            end
          end

          context "without id param" do
            it "enqueues n jobs" do
              expect { get :sync }.to have_enqueued_job(Decidim::Odoo::SyncUsersJob).with(organization.id, nil)

              expect(response).to redirect_to("/admin/odoo/members")
            end
          end
        end
      end
    end
  end
end
