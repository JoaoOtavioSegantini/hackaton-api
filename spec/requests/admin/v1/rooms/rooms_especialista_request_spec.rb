require 'rails_helper'

RSpec.describe "Admin V1 Rooms as :paciente", type: :request do
    let(:login_user) { create(:user, profile: :especialista) }
    let!(:room_feature) { create(:room_feature) }


    context "POST /rooms" do
      let(:url) { "/admin/v1/rooms" }
      
      before(:each) { post url, headers: auth_header(login_user) }
  
      include_examples "forbidden access"
    end
  
    context "PATCH /rooms/:id" do
      let!(:room_feature) { create(:room_feature) }
      let!(:room) { create(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }
     
      let(:url) { "/admin/v1/rooms/#{room.id}" }
  
      before(:each) { patch url, headers: auth_header(login_user) }
  
      include_examples "forbidden access"
    end
  
    context "DELETE /rooms/:id" do
      let!(:room_feature) { create(:room_feature) }
      let!(:room) { create(:room, bathroom: room_feature.bathroom, airConditioned: room_feature.airConditioned, furnished: room_feature.furnished, internet: room_feature.internet, roomCleaning: room_feature.roomCleaning) }
    
      let(:url) { "/admin/v1/rooms/#{room.id}" }
  
      before(:each) { delete url, headers: auth_header(login_user) }
  
      include_examples "forbidden access"
  end
end
