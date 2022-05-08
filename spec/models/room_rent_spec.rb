require 'rails_helper'

RSpec.describe RoomRent, type: :model do
  it { is_expected.to validate_presence_of(:started_at) }
  it { is_expected.to validate_presence_of(:finish_at) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :room }
  it { is_expected.to have_many(:consults) }

  let!(:user) { create(:user) }
  let!(:room) { create(:room) }

  it "can't have past started_at" do
    subject.started_at = 1.day.ago
    subject.valid?
    expect(subject.errors.keys).to include :started_at
  end

  it "is invalid with current date" do
    subject.started_at = Time.zone.now
    subject.valid?
    expect(subject.errors.keys).to include :started_at
  end

  it "is valid with future date" do
    subject.started_at = 1.day.from_now
    subject.finish_at = Time.zone.now + 10.days
    subject.price = Faker::Commerce.price
    subject.user = user
    subject.room = room
    subject.valid?
    expect(subject.errors.keys).to_not include :started_at
  end

  it "can't have past finish_at" do
    subject.finish_at = 1.day.ago
    subject.valid?
    expect(subject.errors.keys).to include :finish_at
  end

  it "is invalid with current finish_at" do
    subject.finish_at = Time.zone.now
    subject.valid?
    expect(subject.errors.keys).to include :finish_at
  end

  it "is invalid with start date is greater than end date" do
    subject.finish_at = 1.day.from_now
    subject.started_at = 2.days.from_now
    subject.valid?
    expect(subject.errors.keys).to include :started_at
  end

  it "is valid with future date" do
    subject.started_at = 2.days.from_now
    subject.finish_at = Time.zone.now + 10.days
    subject.price = Faker::Commerce.price
    subject.user = user
    subject.room = room
    subject.valid?
    expect(subject.errors.keys).to_not include :finish_at
  end
end
