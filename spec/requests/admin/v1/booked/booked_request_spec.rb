require 'rails_helper'

RSpec.describe "Admin::V1::Bookeds", type: :request do
    let!(:login_user) { create(:user) }

    context "GET /booked" do
    let(:url) { "/storefront/v1/consults" }

    end

    context "GET /booked/:id" do
    let(:url) { "/storefront/v1/consults" }

    end

    context "PATCH /booked/:id" do
    let(:url) { "/storefront/v1/consults" }

    end
end
