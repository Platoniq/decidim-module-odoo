# frozen_string_literal: true

require "spec_helper"
require "decidim/odoo/test/shared_contexts"

module Decidim
  module Odoo
    describe SyncUsersJob do
      subject { described_class }

      include_context "with stubs example api"

      let(:data) { JSON.parse(file_fixture("find_partner_by_vat_valid_response.json").read) }

      describe "queue" do
        it "is queued to events" do
          expect(subject.queue_name).to eq "default"
        end
      end

      describe "perform" do
        let(:organization) { create :organization }
        let(:other_organization) { create :organization }
        let!(:odoo_user) { create :odoo_user, organization: organization }
        let!(:other_odoo_user) { create :odoo_user, organization: organization }
        let!(:odoo_user_from_other_org) { create :odoo_user, organization: other_organization }

        before do
          allow(Rails.logger).to receive(:warn).and_call_original
        end

        context "when a odoo user is specified" do
          it "enqueues one job" do
            expect { subject.perform_now(organization.id, odoo_user.id) }.to have_enqueued_job(Decidim::Odoo::OmniauthUserSyncJob).exactly(1)
          end

          context "when the odoo user does not exist" do
            it "does not enqueue job" do
              expect { subject.perform_now(organization.id, -1) }.not_to have_enqueued_job(Decidim::Odoo::OmniauthUserSyncJob)
            end

            it "writes a warn log" do
              subject.perform_now(organization.id, -1)
              expect(Rails.logger).to have_received(:warn).with(/SyncUsersJob: WARN: No results found for/)
            end
          end
        end

        context "when no odoo user is specified" do
          it "enqueues as jobs as users in the organization" do
            expect { subject.perform_now(organization.id, nil) }.to have_enqueued_job(Decidim::Odoo::OmniauthUserSyncJob).exactly(2)
          end
        end
      end
    end
  end
end
