class AddRoomFeaturesToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :internet, :boolean, default: false
    add_column :rooms, :airConditioned, :boolean, default: false
    add_column :rooms, :bathroom, :boolean, default: false
    add_column :rooms, :furnished, :boolean, default: false
    add_column :rooms, :roomCleaning, :boolean, default: false
  end
end
