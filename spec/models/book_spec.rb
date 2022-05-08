require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :room }
  it { is_expected.to define_enum_for(:accepted).with_values({ pending: 0, agreed: 1, rejected: 2 }) }

end
