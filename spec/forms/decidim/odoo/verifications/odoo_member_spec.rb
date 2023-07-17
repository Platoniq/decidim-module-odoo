# frozen_string_literal: true

require "spec_helper"
require "decidim/odoo/test/shared_contexts"

module Decidim::Odoo
  module Verifications
    describe OdooMember do
      subject { described_class.from_params(attributes) }

      include_context "with stubs example api"

      let(:data) { JSON.parse(file_fixture("find_partner_by_vat_valid_response.json").read) }

      let(:attributes) do
        {
          "user" => user
        }
      end
      let(:user) { odoo_user.user }
      let(:odoo_user) { create :odoo_user, member: true }
      let(:metadata) do
        {
          uid: odoo_user.odoo_user_id,
          odoo_user_ref: odoo_user.ref
        }
      end

      context "when everything is ok" do
        it { is_expected.to be_valid }

        it "returns valid metadata" do
          expect(subject.metadata).to eq(metadata)
        end

        it "returns valid organization" do
          expect(subject.send(:organization)).to eq(user.organization)
        end

        it "returns valid odoo user" do
          expect(subject.send(:odoo_user)).to eq(odoo_user)
        end

        it "returns valid odoo_api_user" do
          expect(subject.send(:odoo_api_user)).to eq(data.deep_symbolize_keys)
        end
      end

      context "when the user is not a member" do
        let(:odoo_user) { create :odoo_user }

        it { is_expected.not_to be_valid }
      end

      context "when the user and the api user do not exist" do
        let(:user) { create :user }

        before do
          # rubocop: disable RSpec/AnyInstance
          allow_any_instance_of(Decidim::Odoo::Api::FindPartner).to receive(:result).and_raise(Decidim::Odoo::Error)
          # rubocop: enable RSpec/AnyInstance
        end

        it { is_expected.not_to be_valid }
      end
    end
  end
end
