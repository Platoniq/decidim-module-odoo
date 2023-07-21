# frozen_string_literal: true

require "spec_helper"

describe "rake decidim:odoo:sync:members", type: :task do
  let(:count) { 5 }
  let!(:organizations) { create_list :organization, count }

  context "when executing task" do
    it "enqueues as jobs as organizations in the system" do
      expect { task.execute }.to have_enqueued_job(Decidim::Odoo::SyncUsersJob).exactly(count)
    end
  end
end
