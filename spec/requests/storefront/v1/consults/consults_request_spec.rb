require 'rails_helper'

RSpec.describe "Storefront::V1::Consults", type: :request do
    let!(:login_user) { create(:user) }

    context "GET /consults" do
    let(:url) { "/storefront/v1/consults" }
    let!(:consults) { create_list(:consult, 10, user_id: login_user.id) }
       
    it "returns all Consults" do
     get url, headers: auth_header(login_user)
     expect(body_json['consults'].count).to eq 10
    end

    it "returns success status" do
     get url, headers: auth_header(login_user)
     expect(response).to have_http_status(:ok)
    end 
  end

  context "GET /consult/:id" do
    let!(:payment) { create(:payment) }
    let!(:consult)  { create(:consult, user: login_user, payment_attributes: { amount: payment.amount, method: payment.method, date: payment.date } ) }
    let(:url) { "/storefront/v1/consults/#{consult.id}" }

    it "returns requested Consult" do
      get url, headers: auth_header(login_user)
      expected_consult = build_consult_structure(consult, login_user)
      expect(body_json).to eq expected_consult
    end

    it "returns success status" do
      get url, headers: auth_header(login_user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /consults" do
    let(:url) { "/storefront/v1/consults" }
    let!(:user) { create(:user) }
    let!(:rent) { create(:room_rent)}
    context "with valid params" do
     let(:consult_params) { { consult: attributes_for(:consult, user_id: login_user.id, room_rent_id: rent.id) }.to_json }

     it 'adds a new Consult' do
       expect do
         post url, headers: auth_header(login_user), params: consult_params
       end.to change(Consult, :count).by(1)
     end

     it 'adds a new Book' do
      expect do
        post url, headers: auth_header(login_user), params: consult_params
      end.to change(Book, :count).by(1)
    end

     it 'returns last added Consult' do
       post url, headers: auth_header(login_user), params: consult_params
       expected_return = build_consult_structure(Consult.last, login_user)
       expect(body_json).to eq expected_return
     end

     it 'returns success status' do
       post url, headers: auth_header(login_user), params: consult_params
       expect(response).to have_http_status(:ok)
     end
   end

   context "with invalid params" do
    let(:consult_invalid_params) do 
      { consult: attributes_for(:consult, started_at: nil) }.to_json
    end

    let(:consult_invalid_dates) do 
      { consult: attributes_for(:consult, started_at: 2.days.from_now, finish_at: 1.day.from_now, user_id: login_user.id) }.to_json
    end

  
    it 'does not add a new Consult' do
      expect do
        post url, headers: auth_header(login_user), params: consult_invalid_params
      end.to_not change(Consult, :count)
    end

    it 'returns error message' do
      post url, headers: auth_header(login_user), params: consult_invalid_params
      expect(body_json['errors']['fields']).to have_key('started_at')
      expect(body_json['errors']['fields']).to have_key('room_rent')
    end

    it 'returns unprocessable_entity status' do
      post url, headers: auth_header(login_user), params: consult_invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error message from after_start_date_validator' do
      post url, headers: auth_header(login_user), params: consult_invalid_dates
      expect(response).to have_http_status(:unprocessable_entity)
      expect(body_json['errors']['fields']).to have_key('started_at')
    end
  end 

  context "PATCH /consults/:id" do
    let!(:payment) { create(:payment) }
    let!(:consult)  { create(:consult, user: login_user, payment_attributes: { amount: payment.amount, method: payment.method, date: payment.date } ) }
    let(:url) { "/storefront/v1/consults/#{consult.id}" }

    context "with valid params" do
      let(:new_date) { 1.month.from_now }
      let(:consult_params) { { consult: attributes_for(:consult, user_id: login_user.id, finish_at: new_date) }.to_json }

      it 'updates Consult' do
        patch url, headers: auth_header(login_user), params: consult_params
        consult.reload
        expect(consult.finish_at.strftime('%I:%M:%S %p')).to eq new_date.strftime('%I:%M:%S %p')
      end

      it 'returns updated Consult' do
        patch url, headers: auth_header(login_user), params: consult_params
        consult.reload
        expected_consult = build_consult_structure(consult, login_user)
        expect(body_json).to eq expected_consult
      end

      it 'returns success status' do
        patch url, headers: auth_header(login_user), params: consult_params
        expect(response).to have_http_status(:ok)
      end
    end
  
    context "with invalid params" do
      let(:consult_invalid_params) do 
        { consult: attributes_for(:consult, finish_at: nil) }.to_json
    end

    it 'does not update Consult' do
      old_date = consult.finish_at.strftime('%I:%M:%S %p')
      patch url, headers: auth_header(login_user), params: consult_invalid_params
      consult.reload
      expect(consult.finish_at.strftime('%I:%M:%S %p')).to eq old_date
    end

    it 'returns error message' do
      patch url, headers: auth_header(login_user), params: consult_invalid_params
      expect(body_json['errors']['fields']).to have_key('finish_at')
    end

    it 'returns unprocessable_entity status' do
      patch url, headers: auth_header(login_user), params: consult_invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /consults/:id" do
    let!(:payment) { create(:payment) }
    let!(:consult)  { create(:consult, user: login_user, payment_attributes: { amount: payment.amount, method: payment.method, date: payment.date } ) }
    let(:url) { "/storefront/v1/consults/#{consult.id}" }

    it 'removes Consult' do
      expect do  
        delete url, headers: auth_header(login_user)
      end.to change(Consult, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(login_user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(login_user)
      expect(body_json).to_not be_present
    end

    it 'removes all associated with consult' do
        expect do  
            delete url, headers: auth_header(login_user)
          end.to change(Payment, :count).by(-1)
        end

    it 'does not remove unassociated payments' do
      payments = create_list(:payment, 3)
      delete url, headers: auth_header(user)
      present_payments_ids = payments.map(&:id)
      expected_payments = Payment.where(id: present_payments_ids)
      expect(expected_payments.ids).to contain_exactly(*present_payments_ids)
    end
  end
 end

  def build_consult_structure(consult, user) 
    json = consult.as_json(only: %i[finish_at id payment_info started_at])
    json['payment_info'] = consult.payment.as_json() if consult.payment.present?
    json['user'] = user.as_json() if user.present?
    json
  end
end
