# frozen_string_literal: true

require "spec_helper"

describe "Admin panel", type: :system do
  let(:organization) { create :organization }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.root_path
  end

  it "renders the expected menu" do
    within ".main-nav" do
      expect(page).to have_content("Odoo")
    end

    click_link "Odoo"

    expect(page).to have_content("Odoo Members")
  end

  describe "#members" do
    context "when there are no users" do
      it "shows a warning" do
        visit decidim_odoo_admin.members_path

        expect(page).to have_content("There are no members from Odoo")
      end
    end

    context "when there are multiple users users" do
      let(:two_days_ago) { Time.zone.now - 2.days }
      let(:two_weeks_ago) { Time.zone.now - 2.weeks }
      let(:user_one) { create(:user, :confirmed, organization: organization, nickname: "user_one") }
      let(:user_two) { create(:user, :confirmed, organization: organization, nickname: "user_two") }
      let!(:odoo_user_one) { create :odoo_user, user: user_one, member: true, created_at: two_days_ago, updated_at: two_days_ago }
      let!(:odoo_user_two) { create :odoo_user, user: user_two, coop_candidate: true, created_at: two_weeks_ago, updated_at: two_weeks_ago }
      let!(:odoo_users) do
        create_list(:odoo_user, 20) do |odoo_user|
          odoo_user.user = create(:user, :confirmed, organization: organization)
          odoo_user.organization = organization
          odoo_user.save!
        end
      end

      before do
        visit decidim_odoo_admin.members_path
      end

      it "shows up to 15 rows" do
        within ".odoo-groups tbody" do
          expect(page).to have_selector("tr", count: 15)
        end
      end

      it "shows more than one page" do
        within ".pagination" do
          expect(page).to have_content("Next")
          expect(page).to have_content("Last")
        end
      end

      context "when clicking on show email" do
        it "shows the email in a modal" do
          first("a.action-icon--show-email").click
          within("#show-email-modal") do
            expect(page).to have_content("hidden")
            find("button", text: "Show").click
            sleep(1)
            expect(page).not_to have_content("hidden")
            expect(page).to have_content(odoo_users.last.user.email)
          end
        end
      end

      context "when clicking on contact" do
        it "redirects to a new conversation" do
          first("a.action-icon--new").click
          expect(page).to have_content("Conversation with")
        end
      end

      context "when filtering by an existing user" do
        before do
          within "form" do
            fill_in :q_user_name_or_user_nickname_or_user_email_cont, with: "user_one"
            find("*[type=submit]").click
          end
        end

        it "filters the results" do
          within ".odoo-groups tbody" do
            expect(page).to have_selector("tr", count: 1)
          end
        end
      end

      context "when filtering by a non existing user" do
        before do
          within ".fcell.search form" do
            fill_in :q_user_name_or_user_nickname_or_user_email_cont, with: "Name of non-existing user"
            find("*[type=submit]").click
          end
        end

        it "does not find any results" do
          expect(page).to have_content("There are no members from Odoo")
        end
      end

      context "when filtering by coop candidate" do
        before do
          find("a", text: "Filter").click
          find("a", text: "Is coop candidate").hover
          find("a", text: "Yes").click
        end

        it "shows the selected filter" do
          within ".filter-status" do
            expect(page).to have_content("Is coop candidate: Yes")
          end
        end

        it "filters the results" do
          within ".odoo-groups tbody" do
            expect(page).to have_selector("tr", count: 1)

            within "tr" do
              expect(page).to have_selector("td.success", text: "Yes")
              expect(page).to have_selector("td.alert", text: "No")
              expect(page).to have_selector("td.alert", text: odoo_user_two.updated_at.year)
            end
          end
        end
      end

      context "when filtering by member" do
        before do
          find("a", text: "Filter").click
          find("a", text: "Is member").hover
          find("a", text: "Yes").click
        end

        it "shows the selected filter" do
          within ".filter-status" do
            expect(page).to have_content("Is member: Yes")
          end
        end

        it "filters the results" do
          within ".odoo-groups tbody" do
            expect(page).to have_selector("tr", count: 1)

            within "tr" do
              expect(page).to have_selector("td.success", text: "Yes")
              expect(page).to have_selector("td.alert", text: "No")
              expect(page).to have_selector("td.warning", text: odoo_user_one.updated_at.year)
            end
          end
        end
      end

      context "when filtering by both member and coop candidate" do
        before do
          find("a", text: "Filter").click
          find("a", text: "Is coop candidate").hover
          find("a", text: "Yes").click

          find("a", text: "Filter").click
          find("a", text: "Is member").hover
          find("a", text: "Yes").click
        end

        it "shows the selected filter" do
          within ".filter-status" do
            expect(page).to have_content("Is member: Yes")
            expect(page).to have_content("Is coop candidate: Yes")
          end
        end

        it "does not find any results" do
          expect(page).to have_content("There are no members from Odoo")
        end
      end
    end
  end
end
