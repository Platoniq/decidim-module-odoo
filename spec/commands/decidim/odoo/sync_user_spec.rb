# frozen_string_literal: true

require "spec_helper"
require "decidim/odoo/test/shared_contexts"

module Decidim
  module Odoo
    describe SyncUser do
      subject { described_class.new(user) }

      let(:user) { create :user }
      let(:identity) { create(:identity, user: user, provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME) }
      let(:odoo_info) { { id: ::Faker::Number.number(digits: 4), ref: identity.uid, vat: Decidim::Odoo::Faker.vat, name: "New name", email: user.email } }

      include_context "with stubs example api"

      before do
        # rubocop: disable RSpec/AnyInstance
        allow_any_instance_of(Decidim::Odoo::Api::FindPartner).to receive(:result).and_return(odoo_info)
        # rubocop: enable RSpec/AnyInstance
      end

      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "updates the user information" do
          expect { subject.call }.to change(user, :name)
        end

        it "creates a odoo user" do
          expect { subject.call }.to change(Decidim::Odoo::User, :count).by(1)
        end

        context "when odoo user already exists" do
          let!(:odoo_user) { create :odoo_user, user: user }

          it "updates the updated at column" do
            sleep(1)
            subject.call
            expect(odoo_user.updated_at).to be < odoo_user.reload.updated_at
          end
        end
      end

      context "when user has no odoo identity" do
        before do
          allow(user).to receive(:odoo_identity).and_return(nil)
        end

        it "broadcasts invalid" do
          expect { subject.call }.to broadcast(:invalid)
        end

        it "does not update the user information" do
          expect { subject.call }.not_to change(user, :email)
        end

        it "does not create a odoo user" do
          expect { subject.call }.to change(Decidim::Odoo::User, :count).by(0)
        end
      end
    end
  end
end
