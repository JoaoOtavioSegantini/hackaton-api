require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to validate_presence_of :amount }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:date).on(:create) }

  it { is_expected.to belong_to :consult }

end
