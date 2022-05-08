class RoomFeature < ApplicationRecord
  belongs_to :room
  
  validates  :internet, :airConditioned, :bathroom, :furnished, :roomCleaning, inclusion: { in: [ true, false ] }
end
