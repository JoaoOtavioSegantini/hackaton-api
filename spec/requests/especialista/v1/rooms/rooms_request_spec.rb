require 'rails_helper'

RSpec.describe "Especialista::V1::Rooms", type: :request do
    let!(:login_user) { create(:user, profile: :especialista) }

    context "GET /rooms" do
     let(:url) { "/especialista/v1/rooms" }
     let!(:rooms) { create_list(:room, 10) }
    
     it "returns all Rooms" do
      get url, headers: auth_header(login_user)
      expect(body_json['rooms'].count).to eq 10
     end

     it "returns success status" do
      get url, headers: auth_header(login_user)
      expect(response).to have_http_status(:ok)
     end 

     it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
      before { get url, headers: auth_header(login_user) }
    end

    context "with search[name] param" do
      let!(:search_name_rooms) do
        rooms = [] 
        15.times { |n| rooms << create(:room, name: "Search #{n + 1}") }
        rooms 
      end

      let(:search_params) { { search: { name: "Search" } } }

      it "returns only searched rooms limited by default pagination" do
        get url, headers: auth_header(login_user), params: search_params
        expected_rooms = search_name_rooms[0..9].as_json()
        expect(body_json['rooms']).to contain_exactly *expected_rooms
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
        expect(body_json['rooms'].count).to eq length
      end
      
      it "returns rooms limited by pagination" do
        get url, headers: auth_header(login_user), params: pagination_params
        expected_rooms = rooms[5..9].as_json()
        expect(body_json['rooms']).to contain_exactly *expected_rooms
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
      let(:order_params) { { order: { name: 'desc' } } }
  
      it "returns ordered rooms limited by default pagination" do
        get url, headers: auth_header(login_user), params: order_params
        rooms.sort! { |a, b| b[:name] <=> a[:name] }
        expected_return = rooms[0..9].as_json()
        expect(body_json['rooms']).to contain_exactly *expected_return
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

   context "GET /room/:id" do
    let!(:room_feature) { create(:room_feature) }
    let!(:room) { create(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }

    let(:url) { "/especialista/v1/rooms/#{room.id}" }

    it "returns requested Room" do
      get url, headers: auth_header(login_user)
      expected_room = build_room_structure(room, room_feature)
      expect(body_json).to eq expected_room
    end

    it "returns success status" do
      get url, headers: auth_header(login_user)
      expect(response).to have_http_status(:ok)
    end
  end

  def build_room_structure(room, features) 
      json = room.as_json(only: %i[id name avaliable price description])
      json['features'] = features.as_json(only: %i[airConditioned bathroom furnished internet roomCleaning])
      json
  end
end
