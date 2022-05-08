require 'rails_helper'

RSpec.describe Consult, type: :model do
  it { is_expected.to validate_presence_of(:started_at) }
  it { is_expected.to validate_presence_of(:finish_at) }
  it { is_expected.to have_one(:payment).dependent(:destroy) }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :room_rent }

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
    subject.started_at = Time.zone.now + 1.hour
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

  it "is valid with future date" do
    subject.finish_at = Time.zone.now + 1.hour
    subject.valid?
    expect(subject.errors.keys).to_not include :finish_at
  end
end
