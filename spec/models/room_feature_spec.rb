require 'rails_helper'

RSpec.describe RoomFeature, type: :model do
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
  it { is_expected.to belong_to :room }

end
