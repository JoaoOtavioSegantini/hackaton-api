require 'rails_helper'

RSpec.describe Room, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to allow_value(%w(true false)).for(:avaliable) }
  it { is_expected.not_to allow_value(nil).for(:avaliable) }
  it { is_expected.to allow_value(%w(true false)).for(:internet) }
  it { is_expected.not_to allow_value(nil).for(:internet) }
  it { is_expected.to allow_value(%w(true false)).for(:airConditioned) }
  it { is_expected.not_to allow_value(nil).for(:airConditioned) }
  it { is_expected.to allow_value(%w(true false)).for(:bathroom) }
  it { is_expected.not_to allow_value(nil).for(:bathroom) }
  it { is_expected.to allow_value(%w(true false)).for(:furnished) }
  it { is_expected.not_to allow_value(nil).for(:furnished) }
  it { is_expected.to allow_value(%w(true false)).for(:roomCleaning) }
  it { is_expected.not_to allow_value(nil).for(:roomCleaning) }
  it { is_expected.to have_many(:room_rents).dependent(:destroy) }
  it { is_expected.to have_many(:books).dependent(:destroy) }

  it_behaves_like "paginatable concern", :room
  it_has_behavior_of "like searchable concern", :room, :name

end
