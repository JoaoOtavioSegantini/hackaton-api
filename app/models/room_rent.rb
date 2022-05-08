class RoomRent < ApplicationRecord
  include LikeSearchable
  include Paginatable
  
  belongs_to :user
  belongs_to :room
  has_many :consults
  validates :started_at, :finish_at, presence: true, future_date: true, after_start_date: true
  validates :price, :title, :description, presence: true
  scope :with_aggregates, -> { includes(:user, :room) }

  validate :prevent_duplicate_rentals

  after_create :set_book


  def prevent_duplicate_rentals
      @min_date = self.started_at
      @max_date = self.finish_at
      data_range =  @min_date..@max_date
      range_start = RoomRent.where(room_id: self.room_id, started_at: data_range)
      range_end = RoomRent.where(room_id: self.room_id, finish_at: data_range)
    if range_start.present? && range_end.present?
      errors.add(:room, :rent_not_be_same)
    end
  end

  private 

  def set_book
    Book.transaction  do
      Book.create(user: self.user, admin: true, room_id: self.room_id)
    end 
  end
end
