class AddRoomAvaliable < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :avaliable, :boolean, default: true
  end
end
