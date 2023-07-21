# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/DescribeClass
describe "Automatic verification after oauth sign up" do
  context "when a user is registered with omniauth" do
    let!(:user) { create(:user) }

    it "runs the OmniauthUserSyncJob" do
      expect do
        ActiveSupport::Notifications.publish(
          "decidim.user.omniauth_registration",
          user_id: user.id,
          identity_id: 1234,
          provider: "odoo_keycloak",
          uid: "aaa",
          email: user.email,
          name: "Odoo User",
          nickname: "odoo_user",
          avatar_url: "http://www.example.com/foo.jpg",
          raw_data: {}
        )
      end.to have_enqueued_job(Decidim::Odoo::OmniauthUserSyncJob)
    end
  end
end

# rubocop:enable RSpec/DescribeClass
