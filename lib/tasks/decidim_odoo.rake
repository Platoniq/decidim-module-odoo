# frozen_string_literal: true

namespace :decidim do
  namespace :odoo do
    # invoke with 'bundle exec rake "civicrm:sync:groups"'

    namespace :sync do
      desc "Sync members with Odoo API"
      task members: :environment do
        Decidim::Organization.find_each do |organization|
          Decidim::Odoo::SyncUsersJob.perform_later(organization.id)
        end
      end
    end
  end
end
