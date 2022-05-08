require 'rails_helper'

RSpec.describe "Especialista::V1::BookingValidations", type: :request do
    let!(:login_user) { create(:user, profile: :especialista) }
    let(:room) { create(:room) }
    let(:url) { "/especialista/v1/rooms_rent/#{room.id}/booked" }

    context "with 1 room rent" do
    let!(:rent) { create(:room_rent, started_at: 1.day.from_now, finish_at: 4.days.from_now, room_id: room.id)}

    it 'returns last added Room' do
     get url, headers: auth_header(login_user)
     expected_return = build(RoomRent.last)
     expect(body_json).to eq expected_return
    end
   
    it "returns all dates" do
     get url, headers: auth_header(login_user)
     expect(body_json.count).to eq 1
    end
   
    it "returns success status" do
     get url, headers: auth_header(login_user)
     expect(response).to have_http_status(:ok)
    end 
  end

   context "with more than one room rent" do
    
   let!(:rent2) { create(:room_rent, started_at: 8.day.from_now, finish_at: 25.days.from_now, room_id: room.id)}
   let!(:rent) { create(:room_rent, started_at: 1.day.from_now, finish_at: 4.days.from_now, room_id: room.id)}

      it 'returns all Rooms' do
        get url, headers: auth_header(login_user)
        expected_return = build_array(RoomRent.all)
        expect(body_json).to eq expected_return
      end
      
      it "returns all dates" do
        get url, headers: auth_header(login_user)
        expect(body_json.count).to eq 1
      end
      
      it "returns success status" do
        get url, headers: auth_header(login_user)
        expect(response).to have_http_status(:ok)
      end 
   end

  def build(rent)
    json = rent.as_json(only: %i[range])
    json['range'] = ((rent.started_at..rent.finish_at).to_a).as_json() 
    json
  end

  def build_array(array)
    json = {}
    range = []
    array.map { |data| range.push((data.started_at..data.finish_at).to_a).as_json }
    json['range'] = range.flatten.as_json
    json
  end
end
