# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    let!(:user) { create(:user) }
    let!(:organization) { user.organization }

    describe "#odoo_identity?" do
      subject { user.odoo_identity? }

      context "when user has a odoo-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME) }

        it { is_expected.to be_truthy }
      end

      context "when user doesn't have a odoo-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: "other") }

        it { is_expected.to be_falsey }
      end

      context "when user doesn't have an identity" do
        it { is_expected.to be_falsey }
      end
    end

    describe "#odoo_identity" do
      subject { user.odoo_identity }

      context "when user has a odoo-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: Decidim::Odoo::OMNIAUTH_PROVIDER_NAME) }

        it { is_expected.to be_a Decidim::Identity }
      end

      context "when user doesn't have a odoo-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: "other") }

        it { is_expected.to be_nil }
      end

      context "when user doesn't have an identity" do
        it { is_expected.to be_nil }
      end
    end

    describe "#odoo_user" do
      subject { user.odoo_user }

      context "when user has a related odoo contact" do
        let!(:contact) { create(:odoo_user, organization: organization, user: user) }

        it { is_expected.to be_a Decidim::Odoo::User }
      end
    end
  end
end
