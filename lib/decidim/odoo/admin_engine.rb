# frozen_string_literal: true

module Decidim
  module Odoo
    # This is the engine that runs on the admin interface of decidim-odoo.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Odoo::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :members, only: [:index] do
          collection do
            get :sync
          end
        end

        root to: "members#index"
      end

      initializer "decidim_odoo.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim.odoo.mount_admin_engine" do
        Decidim::Core::Engine.routes do
          mount Decidim::Odoo::AdminEngine, at: "/admin/odoo", as: "decidim_odoo_admin"
        end
      end

      initializer "decidim.odoo.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.add_item :odoo,
                        "Odoo",
                        decidim_odoo_admin.members_path,
                        icon_name: "people",
                        position: 5.75,
                        active: is_active_link?(decidim_odoo_admin.members_path, :inclusive),
                        if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end
