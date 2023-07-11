# frozen_string_literal: true

shared_context "with stubs example api" do
  let(:http_method) { :get }
  let(:http_status) { 200 }
  let(:data) { { "foo" => "bar" } }
  let(:params) { {} }

  before do
    stub_request(http_method, /api\.example\.org/).to_return(status: http_status, body: data.to_json, headers: {})
  end
end
