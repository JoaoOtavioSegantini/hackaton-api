class AddEspecializationToRoomRents < ActiveRecord::Migration[6.0]
  def change
    add_column :room_rents, :especialization, :text
  end
end
