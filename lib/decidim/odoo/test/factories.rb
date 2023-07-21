# frozen_string_literal: true

require "decidim/core/test/factories"

module Decidim::Odoo::Faker
  class << self
    def vat
      "ES#{Faker::IDNumber.spanish_citizen_number.tr("-", "")}"
    end
  end
end

FactoryBot.define do
  factory :odoo_user, class: "Decidim::Odoo::User" do
    user
    organization { user.organization }
    odoo_user_id { Faker::Number.between(from: 1, to: 100_000) }
    ref { Faker::Number.between(from: 1, to: 100_000).to_s }
    coop_candidate { false }
    member { false }
  end
end
