# frozen_string_literal: true

require "spec_helper"
require "decidim/oddoo/test/shared_contexts"

module Decidim
  describe Oddoo::Api::Base::Request, type: :class do
    subject { described_class }

    include_context "with stubs example api"

    describe "#get petition" do
      it "returns a connection instance" do
        expect(subject.get("", params: params).connection).to be_a(Faraday::Connection)
      end

      it "returns a response parsed into a ruby Hash" do
        expect(subject.get("", params: params).response).to be_a(Hash)
        expect(subject.get("", params: params).response).to eq(data)
      end

      context "when is not successful" do
        let(:http_status) { 500 }

        it "throws error" do
          expect { subject.get("", params: params) }.to raise_error Decidim::Oddoo::Error
        end
      end
    end

    describe "#post petition" do
      let(:http_method) { :post }

      it "returns a connection instance" do
        expect(subject.post("", params: params).connection).to be_a(Faraday::Connection)
      end

      it "returns a response parsed into a ruby Hash" do
        expect(subject.post("", params: params).response).to be_a(Hash)
        expect(subject.post("", params: params).response).to eq(data)
      end

      context "when is not successful" do
        let(:http_status) { 500 }

        it "throws error" do
          expect { subject.post("", params: params) }.to raise_error Decidim::Oddoo::Error
        end
      end
    end
  end
end
