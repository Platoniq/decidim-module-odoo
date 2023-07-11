# frozen_string_literal: true

require "spec_helper"
require "decidim/odoo/test/shared_contexts"

module Decidim
  describe Odoo::Api::FindPartnerByVat, type: :class do
    subject { described_class.new("ES88773284T") }

    include_context "with stubs example api"

    let(:data) { JSON.parse(file_fixture("find_partner_by_vat_valid_response.json").read) }

    describe "#result" do
      it "returns a mapped object" do
        expect(subject.result).to be_a Hash
        expect(subject.result[:id]).to be_a Integer
        expect(subject.result[:ref]).to be_a String
        expect(subject.result[:addresses]).to be_a Array
        expect(subject.result[:id]).to eq(data["id"])
        expect(subject.result[:name]).to eq(data["name"])
        expect(subject.result[:ref]).to eq(data["ref"])
        expect(subject.result[:vat]).to eq(data["vat"])
        expect(subject.result[:coop_candidate]).to be true
        expect(subject.result[:addresses][1][:zip_code]).to eq(data["addresses"][1]["zip_code"])
      end
    end
  end
end
