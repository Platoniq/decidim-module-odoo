# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Odoo::Api::Base::BaseQuery, type: :class do
    subject { described_class.new }

    describe "#parsed_response" do
      it "raises an exception because it's a not implemented method" do
        expect { subject.send(:parsed_response) }.to raise_error NotImplementedError
      end
    end
  end
end
