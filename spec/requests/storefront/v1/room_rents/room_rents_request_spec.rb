require 'rails_helper'

RSpec.describe "Storefront::V1::RoomRents", type: :request do
    let!(:login_user) { create(:user, profile: :paciente) }

    context "GET /room_rents" do
    let(:url) { "/storefront/v1/room_rents" }
    let!(:room_rents) { create_list(:room_rent, 10) }
       
    it "returns all Rooms" do
     get url, headers: auth_header(login_user)
     expect(body_json['rents'].count).to eq 10
    end

    it "returns success status" do
     get url, headers: auth_header(login_user)
     expect(response).to have_http_status(:ok)
    end 

    it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
      before { get url, headers: auth_header(login_user) }
    end

    context "with search[title] param" do

      let(:search_params) { { search: { title: "Search" } } }

      let!(:search_name_rooms) do
        room_rents = [] 
        15.times { |n| room_rents << create(:room_rent, title: "Search #{n + 1}") }
        room_rents 
      end

      it "returns only searched rooms limited by default pagination" do
        get url, headers: auth_header(login_user), params: search_params
        expected_rooms = search_name_rooms[0..9].as_json()
        expect(body_json['rents']).to contain_exactly *expected_rooms
      end

      it "returns success status" do
        get url, headers: auth_header(login_user), params: search_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 15, total_pages: 2 } do
        before { get url, headers: auth_header(login_user), params: search_params }
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(login_user), params: pagination_params
        expect(body_json['rents'].count).to eq length
      end
      
      it "returns rooms limited by pagination" do
        get url, headers: auth_header(login_user), params: pagination_params
        expected_rooms = room_rents[5..9].as_json()
        expect(body_json['rents']).to contain_exactly *expected_rooms
      end

      it "returns success status" do
        get url, headers: auth_header(login_user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 10, total_pages: 2 } do
        before { get url, headers: auth_header(login_user), params: pagination_params }
      end
    end

    context "with order params" do
      let(:order_params) { { order: { title: 'desc' } } }
  
      it "returns ordered rooms limited by default pagination" do
        get url, headers: auth_header(login_user), params: order_params
        room_rents.sort! { |a, b| b[:title] <=> a[:title] }
        expected_return = room_rents[0..9].as_json()
        expect(body_json['rents']).to contain_exactly *expected_return
      end
  
      it "returns success status" do
        get url, headers: auth_header(login_user), params: order_params
        expect(response).to have_http_status(:ok)
      end
  
      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(login_user), params: order_params }
      end
    end  
  end

  context "GET /room_rents/:id" do
    let!(:room_rent) { create(:room_rent) }
    let(:url) { "/storefront/v1/room_rents/#{room_rent.id}" }

    it "returns requested Consult" do
      get url, headers: auth_header(login_user)
      expected_consult = build_room_rent_structure(room_rent)
      expect(body_json).to eq expected_consult
    end

    it "returns success status" do
      get url, headers: auth_header(login_user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /room_rents" do
    let(:url) { "/storefront/v1/room_rents" }

    context "with valid params" do
      let!(:room) { create(:room) }
      let!(:room_rent_params) { { room_rent: attributes_for(:room_rent, user_id: login_user.id, room_id: room.id) }.to_json }
      let!(:rent) { create(:room_rent, started_at: 1.day.from_now, finish_at: 2.days.from_now, room_id: room.id)}
      let!(:params_new) { { room_rent: attributes_for(:room_rent, user_id: login_user.id, room_id: room.id, started_at: 1.day.from_now, finish_at: 2.days.from_now) }.to_json }

     it 'adds a new room_rent' do
       expect do
         post url, headers: auth_header(login_user), params: room_rent_params
       end.to change(RoomRent, :count).by(1)
     end

     it 'returns last added Room' do
       post url, headers: auth_header(login_user), params: room_rent_params
       expected_return = build_room_rent_structure(RoomRent.last)
       expect(body_json).to eq expected_return
     end

     it 'on rent duplication do not add new room_rent' do
      expect do
        post url, headers: auth_header(login_user), params: params_new
      end.to_not change(RoomRent, :count)
      expect(body_json['errors']['fields']).to have_key('room')
    end

     it 'returns success status' do
       post url, headers: auth_header(login_user), params: room_rent_params
       expect(response).to have_http_status(:ok)
     end
   end

   context "with invalid params" do
    let(:room_rent_invalid_params) do 
      { room_rent: attributes_for(:room_rent, started_at: nil) }.to_json
    end

    let(:room_rent_invalid_dates) do 
      { room_rent: attributes_for(:room_rent, started_at: 2.days.from_now, finish_at: 1.day.from_now) }.to_json
    end

  
    it 'does not add a new Consult' do
      expect do
        post url, headers: auth_header(login_user), params: room_rent_invalid_params
      end.to_not change(RoomRent, :count)
    end

    it 'returns error message' do
      post url, headers: auth_header(login_user), params: room_rent_invalid_params
      expect(body_json['errors']['fields']).to have_key('started_at')
      expect(body_json['errors']['fields']).to have_key('room')
    end

    it 'returns unprocessable_entity status' do
      post url, headers: auth_header(login_user), params: room_rent_invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error message from after_start_date_validator' do
      post url, headers: auth_header(login_user), params: room_rent_invalid_dates
      expect(response).to have_http_status(:unprocessable_entity)
      expect(body_json['errors']['fields']).to have_key('started_at')
    end
  end 

  context "PATCH /especialista/v1/room_rents/:id" do
    let!(:room_rent) { create(:room_rent) }
    let(:url) { "/storefront/v1/room_rents/#{room_rent.id}" }

    context "with valid params" do
      let(:new_date) { 5.days.from_now }
      let(:room_rent_params) { { room_rent: attributes_for(:room_rent, started_at: new_date) }.to_json }

      it 'updates Consult' do
        patch url, headers: auth_header(login_user), params: room_rent_params
        room_rent.reload
        expect(room_rent.started_at).to eq new_date.strftime("%a, %e %b %Y").to_date
      end

      it 'returns updated Consult' do
        patch url, headers: auth_header(login_user), params: room_rent_params
        room_rent.reload
        expected_result = build_room_rent_structure(room_rent)
        expect(body_json).to eq expected_result
      end

      it 'returns success status' do
        patch url, headers: auth_header(login_user), params: room_rent_params
        expect(response).to have_http_status(:ok)
      end
    end
  
    context "with invalid params" do
      let(:room_rent_invalid_params) do 
        { room_rent: attributes_for(:room_rent, finish_at: nil) }.to_json
    end

    it 'does not update room_rent' do
      old_date = room_rent.finish_at.strftime('%I:%M:%S %p')
      patch url, headers: auth_header(login_user), params: room_rent_invalid_params
      room_rent.reload
      expect(room_rent.finish_at.strftime('%I:%M:%S %p')).to eq old_date
    end

    it 'returns error message' do
      patch url, headers: auth_header(login_user), params: room_rent_invalid_params
      expect(body_json['errors']['fields']).to have_key('finish_at')
    end

    it 'returns unprocessable_entity status' do
      patch url, headers: auth_header(login_user), params: room_rent_invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /room_rents/:id" do
    let!(:room_rent) { create(:room_rent) }
    let(:url) { "/storefront/v1/room_rents/#{room_rent.id}" }

    it 'removes RoomRent' do
      expect do  
        delete url, headers: auth_header(login_user)
      end.to change(RoomRent, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(login_user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(login_user)
      expect(body_json).to_not be_present
    end
  end
 end

  def build_room_rent_structure(room_rent) 
    json = room_rent.as_json(only: %i[id description room user price])
    json['name'] = room_rent.title
    json['avaliable'] = room_rent.room.avaliable if room_rent.room.present?
    json['room'] = room_rent.room.as_json(only: %i[id name price]) if room_rent.room.present?
    json['user'] = room_rent.user.as_json() if room_rent.user.present?
    json
  end
end
