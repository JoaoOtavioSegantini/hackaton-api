class Book < ApplicationRecord
  belongs_to :user
  belongs_to :room

  scope :with_aggregates, -> { includes(:user, :room) }

  enum accepted: { pending: 0, agreed: 1, rejected: 2 }

end
