# frozen_string_literal: true

require "spec_helper"
require "decidim/odoo/test/shared_contexts"

module Decidim
  module Odoo
    describe OmniauthUserSyncJob do
      subject { described_class }

      describe "queue" do
        it "is queued to events" do
          expect(subject.queue_name).to eq "default"
        end
      end

      include_context "with stubs example api"

      describe "perform" do
        let(:user) { create :user }
        let(:params) { { user_id: user.id } }

        before do
          allow(Rails.logger).to receive(:info).and_call_original
          allow(Rails.logger).to receive(:error).and_call_original
          subject.perform_now(params)
        end

        context "when the user has no identity" do
          it "does not call the sync job" do
            expect(Decidim::Odoo::SyncUser).not_to receive(:call)
          end
        end

        context "when the user has identity" do
          let!(:identity) { create(:identity, user: user, provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME) }

          context "when the sync runs successfully" do
            it "writes an info log" do
              subject.perform_now(params)
              expect(Rails.logger).to have_received(:info).with(/OmniauthUserSyncJob: Success/)
            end
          end

          context "when the sync fails" do
            before do
              # rubocop: disable RSpec/AnyInstance
              allow_any_instance_of(Decidim::Odoo::SyncUser).to receive(:update_user!).and_raise
              # rubocop: enable RSpec/AnyInstance
            end

            it "writes an error log" do
              subject.perform_now(params)
              expect(Rails.logger).to have_received(:error).with(/OmniauthUserSyncJob: ERROR/)
            end
          end
        end
      end
    end
  end
end
