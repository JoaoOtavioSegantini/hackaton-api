require 'rails_helper'

RSpec.describe "Storefront V1 Rooms without authentication", type: :request do
  
  context "GET /rooms" do
    let(:url) { "/storefront/v1/rooms" }
    let!(:rooms) { create_list(:room, 5) }

    before(:each) { get url }
    
    include_examples "unauthenticated access"
  end

  context "GET /rooms/:id" do
    let(:room) { create(:room) }
    let(:url) { "/storefront/v1/rooms/#{room.id}" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end
end