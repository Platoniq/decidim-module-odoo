# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Odoo
    describe User do
      let!(:odoo_user) { create :odoo_user }

      describe "#odoo_member?" do
        context "when the user is not member neither coop candidate" do
          it "is not a odoo member" do
            expect(odoo_user.odoo_member?).to be(false)
          end
        end

        context "when the user is member" do
          before do
            allow(odoo_user).to receive(:member).and_return(true)
          end

          it "is a odoo member" do
            expect(odoo_user.odoo_member?).to be(true)
          end
        end

        context "when the user is member" do
          before do
            allow(odoo_user).to receive(:coop_candidate).and_return(true)
          end

          it "is a odoo member" do
            expect(odoo_user.odoo_member?).to be(true)
          end
        end

        context "when the user is member and coop candidate" do
          before do
            allow(odoo_user).to receive(:member).and_return(true)
            allow(odoo_user).to receive(:coop_candidate).and_return(true)
          end

          it "is a odoo member" do
            expect(odoo_user.odoo_member?).to be(true)
          end
        end
      end

      context "when a user is deleted" do
        subject { Decidim::User.destroy(odoo_user.user.id) }

        it "removes the odoo user too" do
          expect { subject }.to change(Decidim::Odoo::User, :count).by(-1)
        end
      end

      context "when an odoo user is deleted" do
        subject { Decidim::Odoo::User.destroy(odoo_user.id) }

        it "does not remove the user" do
          expect { subject }.to change(Decidim::User, :count).by(0)
        end
      end
    end
  end
end
