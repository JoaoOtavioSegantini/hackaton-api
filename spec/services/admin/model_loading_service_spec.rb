require "rails_helper"

describe Admin::ModelLoadingService do
    context "when #call" do
      let!(:users) { create_list(:user, 15) }
  
      context "when params are present" do
        let!(:search_users) do
            users = []
            15.times { |n| users << create(:user, name: "Search #{n + 1}") }
            users
        end

        let!(:unexpected_users) do
          users = []
          15.times do |n| 
            users << create(:user, name: "Unexpected #{n + 16}")
          end
          users
        end

        let(:params) do
            { search: { name: "Search" }, order: { name: :desc }, page: 2, length: 4 }
        end

        it "returns right :length following pagination" do
            service = described_class.new(User.all, params)
            service.call
            expect(service.records.count).to eq 4
        end

        it "returns records following search, order and pagination" do
            search_users.sort! { |a, b| b[:name] <=> a[:name] }
            service = described_class.new(User.all, params)
            service.call
            expected_users = search_users[4..7]
            expect(service.records).to contain_exactly *expected_users
        end

        it "sets right :page" do
          service = described_class.new(User.all, params)
          service.call
          expect(service.pagination[:page]).to eq 2
        end
  
        it "sets right :length" do
          service = described_class.new(User.all, params)
          service.call
          expect(service.pagination[:length]).to eq 4
        end
  
        it "sets right :total" do
          service = described_class.new(User.all, params)
          service.call
          expect(service.pagination[:total]).to eq 15
        end
  
        it "sets right :total_pages" do
          service = described_class.new(User.all, params)
          service.call
          expect(service.pagination[:total_pages]).to eq 4
        end
  
        it "does not return unenexpected records" do
          params.merge!(page: 1, length: 50)
          service = described_class.new(User.all, params)
          service.call
          expect(service.records).to_not include *unexpected_users
        end
      end
  
      context "when params are not present" do
        it "returns default :length pagination" do
            service = described_class.new(User.all, nil)
            service.call
            expect(service.records.count).to eq 10
        end
        
          it "returns first 10 records" do
            service = described_class.new(User.all, nil)
            service.call
            expected_users = users[0..9]
            expect(service.records).to contain_exactly *expected_users
        end

        it "sets right :page" do
          service = described_class.new(User.all, nil)
          service.call
          expect(service.pagination[:page]).to eq 1
        end
  
        it "sets right :length" do
          service = described_class.new(User.all, nil)
          service.call
          expect(service.pagination[:length]).to eq 10
        end
  
        it "sets right :total" do
          service = described_class.new(User.all, nil)
          service.call
          expect(service.pagination[:total]).to eq 15
        end
  
        it "sets right :total_pages" do
          service = described_class.new(User.all, nil)
          service.call
          expect(service.pagination[:total_pages]).to eq 2
        end
      end
    end
  end