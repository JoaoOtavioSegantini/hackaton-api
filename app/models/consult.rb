class Consult < ApplicationRecord
  belongs_to :user
  belongs_to :room_rent
  has_one :payment, dependent: :destroy

  validates :started_at, :finish_at, presence: true, future_date: true, after_start_date: true
  accepts_nested_attributes_for :payment, allow_destroy: true
  scope :with_aggregates, -> { includes(:user, :payment) }

  validate :prevent_duplicate_consults

  after_create :set_book

  def prevent_duplicate_consults
      @min_date = self.started_at
      @max_date = self.finish_at
      data_range =  @min_date..@max_date
      range_start = Consult.where(room_rent_id: self.room_rent_id, started_at: data_range)
      range_end = Consult.where(room_rent_id: self.room_rent_id, finish_at: data_range)
    if range_start.present? && range_end.present?
      errors.add(:room_rent, :unavailable_date)
    end
  end

  private 

  def set_book
    Book.transaction  do
      Book.create(user: self.user, recepient_id: self.room_rent.user_id, room_id: self.room_rent.room_id)
    end 
  end
end
