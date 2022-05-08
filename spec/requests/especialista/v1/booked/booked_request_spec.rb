require 'rails_helper'

RSpec.describe "Especialista::V1::Bookeds", type: :request do
    let!(:login_user) { create(:user, profile: :especialista) }
    let!(:user) { create(:user) }

 context "GET /booked" do
    let(:url) { "/especialista/v1/booked" }

      10.times do |n|
        let!(:room_rent) { create(:room_rent, user_id: login_user.id) }
        let!(:consults) { create(:consult, user_id: user.id, room_rent_id: room_rent.id, started_at: (n + 1).days.from_now, finish_at: (n + 1).days.from_now )}
    end

      
    it "returns all Booked Consults" do
    get url, headers: auth_header(login_user)
      expect(body_json['consultOrders'].count).to eq 1
    end

    it "returns success status" do
    get url, headers: auth_header(login_user)
    expect(response).to have_http_status(:ok)
    end 
  end

  context "GET /booked/:id" do
    let(:url) { "/especialista/v1/booked" }

  end

  context "PATCH /booked/:id" do
    let(:url) { "/especialista/v1/booked" }

  end
end
