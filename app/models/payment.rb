class Payment < ApplicationRecord
  belongs_to :consult

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  
end
