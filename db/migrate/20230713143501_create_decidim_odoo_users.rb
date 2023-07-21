# frozen_string_literal: true

class CreateDecidimOdooUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_odoo_users do |t|
      t.references :decidim_organization, null: false, foreign_key: { to_table: :decidim_organizations }, index: { name: :index_odoo_users_on_decidim_organization_id }
      t.references :decidim_user, null: false, foreign_key: { to_table: :decidim_users }, index: { name: :index_odoo_users_on_decidim_user_id }

      t.integer :odoo_user_id
      t.string :ref
      t.boolean :coop_candidate, default: false
      t.boolean :member, default: false

      t.timestamps

      t.index %w(decidim_organization_id odoo_user_id), name: "index_unique_odoo_user_and_organization", unique: true
      t.index %w(decidim_organization_id ref), name: "index_unique_ref_and_organization", unique: true
    end
  end
end
