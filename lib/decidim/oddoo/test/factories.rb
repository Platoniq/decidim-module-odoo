# frozen_string_literal: true

require "decidim/core/test/factories"

module Decidim::Oddoo::Faker
  class << self
    def vat
      "ES#{Faker::IDNumber.spanish_citizen_number.tr("-", "")}"
    end
  end
end
