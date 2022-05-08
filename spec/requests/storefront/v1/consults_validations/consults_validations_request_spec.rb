require 'rails_helper'

RSpec.describe "Storefront::V1::ConsultsValidations", type: :request do
    let!(:login_user) { create(:user) }
    let!(:room_rent) { create(:room_rent) }

    let(:url) { "/storefront/v1/consults/#{room_rent.id}/validations" }
    
    context "with one consult" do
      let!(:consult) { create(:consult, room_rent_id: room_rent.id)}

    it 'returns booked consults' do
     get url, headers: auth_header(login_user)
     expected_return = build(Consult.last)
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
    context "with more than one consult" do
    
      let!(:consult) { create(:consult, room_rent_id: room_rent.id)}
      let!(:consult2) { create(:consult, room_rent_id: room_rent.id)}
   
         it 'returns all Consults' do
           get url, headers: auth_header(login_user)
           expected_return = build_array(Consult.all)
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
    json['range'] = ((rent.started_at.to_date..rent.finish_at.to_date).to_a).as_json()
    json
  end

  def build_array(array)
    json = {}
    range = []
    array.map { |data| range.push((data.started_at.to_date..data.finish_at.to_date).to_a).as_json }
    json['range'] = range.flatten.as_json
    json
  end
end
