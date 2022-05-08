require 'rails_helper'

RSpec.describe "Admin::V1::Rooms", type: :request do
    let!(:login_user) { create(:user) }
    let!(:room_feature) { create(:room_feature) }

    context "POST /rooms" do
        let(:url) { "/admin/v1/rooms" }
     
        context "with valid params" do
         let!(:room_params) { { room: attributes_for(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }.to_json }
   
         it 'adds a new Room' do
           expect do
             post url, headers: auth_header(login_user), params: room_params
           end.to change(Room, :count).by(1)
         end
   
         it 'returns last added Room' do
           post url, headers: auth_header(login_user), params: room_params
           expected_room = Room.last.as_json(only: %i[id name avaliable price description features])
           expected_room['features'] = room_feature.as_json(only: %i[airConditioned bathroom furnished internet roomCleaning])
           expect(body_json).to eq expected_room
         end
   
         it 'returns success status' do
           post url, headers: auth_header(login_user), params: room_params
           expect(response).to have_http_status(:ok)
         end
       end
     
        context "with invalid params" do
         let(:room_invalid_params) do 
           { room: attributes_for(:room, name: nil) }.to_json
         end
       
         it 'does not add a new Room' do
           expect do
             post url, headers: auth_header(login_user), params: room_invalid_params
           end.to_not change(Room, :count)
         end
   
         it 'returns error message' do
           post url, headers: auth_header(login_user), params: room_invalid_params
           expect(body_json['errors']['fields']).to have_key('name')
         end
   
         it 'returns unprocessable_entity status' do
           post url, headers: auth_header(login_user), params: room_invalid_params
           expect(response).to have_http_status(:unprocessable_entity)
         end
       end 
    end

    context "PATCH /rooms/:id" do
      let!(:room_feature) { create(:room_feature) }
      let!(:room) { create(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }
  
      let(:url) { "/admin/v1/rooms/#{room.id}" }

      context "with valid params" do
        let(:new_name) { 'My new Room' }
        let!(:room_params) { { room: attributes_for(:room, name: new_name, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }.to_json }

        it 'updates Room' do
          patch url, headers: auth_header(login_user), params: room_params
          room.reload
          expect(room.name).to eq new_name
        end

        it 'returns updated Room' do
          patch url, headers: auth_header(login_user), params: room_params
          room.reload
          expected_room = room.as_json(only: %i[id name avaliable price description features])
          expected_room['features'] = room_feature.as_json(only: %i[airConditioned bathroom furnished internet roomCleaning])
          expect(body_json).to eq expected_room
        end

        it 'returns success status' do
          patch url, headers: auth_header(login_user), params: room_params
          expect(response).to have_http_status(:ok)
        end
      end
    
      context "with invalid params" do
        let(:room_invalid_params) do 
          {  room: attributes_for(:room, description: nil, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }.to_json
        end

        it 'does not update Room' do
          old_name = room.name
          patch url, headers: auth_header(login_user), params: room_invalid_params
          room.reload
          expect(room.name).to eq old_name
        end

        it 'returns error message' do
          patch url, headers: auth_header(login_user), params: room_invalid_params
          expect(body_json['errors']['fields']).to have_key('description')
        end

        it 'returns unprocessable_entity status' do
          patch url, headers: auth_header(login_user), params: room_invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "DELETE /rooms/:id" do
      let!(:room_feature) { create(:room_feature) }
      let!(:room) { create(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }
  
      let(:url) { "/admin/v1/rooms/#{room.id}" }

      it 'removes Room' do
        expect do  
          delete url, headers: auth_header(login_user)
        end.to change(Room, :count).by(-1)
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
