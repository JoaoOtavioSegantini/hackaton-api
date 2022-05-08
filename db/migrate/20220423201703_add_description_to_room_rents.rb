class AddDescriptionToRoomRents < ActiveRecord::Migration[6.0]
  def change
    add_column :room_rents, :description, :text
  end
end
