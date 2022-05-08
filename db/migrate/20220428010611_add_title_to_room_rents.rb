class AddTitleToRoomRents < ActiveRecord::Migration[6.0]
  def change
    add_column :room_rents, :title, :string
  end
end
