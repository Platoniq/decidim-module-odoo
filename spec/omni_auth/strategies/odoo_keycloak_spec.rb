# frozen_string_literal: true

describe OmniAuth::Strategies::OdooKeycloak do
  subject do
    described_class.new({}, client_id, client_secret, client_options: client_options).tap do |strategy|
      allow(strategy).to receive(:request).and_return(request)
      allow(strategy).to receive(:session).and_return([])
    end
  end

  let(:client_id) { "Example-Client" }
  let(:client_secret) { "Example-Secret" }
  let(:client_options) { { site: "https://fake.odoo.site", realm: "example-realm" } }
  let(:request) { double("Request", params: {}, cookies: {}, env: {}, scheme: "https", url: "") }

  let(:id) { Faker::Number.number(digits: 4) }
  let(:ref) { Faker::Number.number(digits: 6) }
  let(:vat) { Decidim::Odoo::Faker.vat }
  let(:email) { Faker::Internet.email }
  let(:name) { Faker::Name.name }

  let(:odoo_info) { { id: id, ref: ref, vat: vat, name: name, email: email } }

  describe "client options" do
    it "has correct name" do
      expect(subject.options.name).to eq("odoo_keycloak")
    end

    it "has correct client id" do
      expect(subject.options.client_id).to eq(client_id)
    end

    it "has correct client secret" do
      expect(subject.options.client_secret).to eq(client_secret)
    end

    it "has correct site" do
      expect(subject.options.client_options.site).to eq(client_options[:site])
    end

    it "has correct realm" do
      expect(subject.options.client_options.realm).to eq(client_options[:realm])
    end
  end

  describe "info" do
    before do
      # rubocop: disable RSpec/SubjectStub
      # rubocop: disable RSpec/AnyInstance
      allow_any_instance_of(Decidim::Odoo::Api::FindPartnerByVat).to receive(:initialize).and_return(nil)
      allow_any_instance_of(Decidim::Odoo::Api::FindPartnerByVat).to receive(:result).and_return(odoo_info)
      allow(subject).to receive(:raw_info).and_return({})
      # rubocop: enable RSpec/SubjectStub
      # rubocop: enable RSpec/AnyInstance
    end

    it "returns the uid" do
      expect(subject.uid).to eq(ref)
    end

    it "returns the nickname" do
      expect(subject.info[:nickname]).to eq(vat)
    end

    it "returns the email" do
      expect(subject.info[:email]).to eq(email)
    end

    it "returns the name" do
      expect(subject.info[:name]).to eq(name)
    end
  end
end
