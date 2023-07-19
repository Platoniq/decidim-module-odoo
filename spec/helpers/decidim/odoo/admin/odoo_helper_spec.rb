# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Odoo
    module Admin
      describe OdooHelper do
        describe "#boolean_class" do
          subject { helper.boolean_class(param) }

          context "when true" do
            let(:param) { true }

            it "returns success" do
              expect(subject).to eq("success")
            end
          end

          context "when false" do
            let(:param) { false }

            it "returns alert" do
              expect(subject).to eq("alert")
            end
          end

          context "when nil" do
            let(:param) { nil }

            it "returns success" do
              expect(subject).to eq("alert")
            end
          end
        end

        describe "#last_sync_class" do
          subject { helper.last_sync_class(param) }

          context "when today" do
            let(:param) { Time.zone.now.at_beginning_of_day }

            it "returns success" do
              expect(subject).to eq("success")
            end
          end

          context "when older than 1 day" do
            let(:param) { Time.zone.now - 2.days }

            it "returns warning" do
              expect(subject).to eq("warning")
            end
          end

          context "when older than 1 week" do
            let(:param) { Time.zone.now - 2.weeks }

            it "returns alert" do
              expect(subject).to eq("alert")
            end
          end
        end
      end
    end
  end
end
