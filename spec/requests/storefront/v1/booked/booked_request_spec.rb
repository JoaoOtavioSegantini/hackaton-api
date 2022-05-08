require 'rails_helper'

RSpec.describe "Storefront::V1::Bookeds", type: :request do
    let!(:login_user) { create(:user) }



  context "GET /booked" do
    let(:url) { "/storefront/v1/booked" }

   # let!(:room_rents) { create_list(:room_rent, 10) }
    10.times do |n|
        let!(:room_rent) { create(:room_rent) }
        let!(:consults) { create(:consult, user_id: login_user.id, room_rent_id: room_rent.id, started_at: (n + 1).days.from_now, finish_at: (n + 1).days.from_now )}
     end

       
    it "returns all Booked Consults" do
     get url, headers: auth_header(login_user)
     consults.reload
      expect(body_json['consultsBooked'].count).to eq 1
    #   expect(Consult.all.to_a.as_json.count).to eq 10
    #   expected_return = Consult.all.to_a.as_json
    #   expect(body_json).to eq expected_return
    end

    it "returns success status" do
     get url, headers: auth_header(login_user)
     expect(response).to have_http_status(:ok)
    end 
  end

  context "GET /booked/:id" do
    let(:url) { "/storefront/v1/consults" }

  end

  context "PATCH /booked/:id" do
    let(:url) { "/storefront/v1/consults" }

  end
end
