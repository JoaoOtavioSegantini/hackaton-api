require 'rails_helper'

RSpec.describe "Auth V1 Sign in", type: :request do
  context "as :admin" do
    let!(:user) { create(:user, email: "admin@test.com", password: "123456") }

    include_examples 'sign in', 'admin@test.com', '123456'
  end

  context "as :paciente" do
    let!(:user) { create(:user, profile: :paciente, email: "client@test.com", password: "123456") }

    include_examples 'sign in', 'client@test.com', '123456'
  end

  context "as :especialista" do
    let!(:user) { create(:user, profile: :especialista, email: "especialista@test.com", password: "123456") }

    include_examples 'sign in', 'especialista@test.com', '123456'
  end
end