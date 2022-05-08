class CreateRoomFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :room_features do |t|
      t.boolean :internet
      t.boolean :airConditioned
      t.boolean :bathroom
      t.boolean :furnished
      t.boolean :roomCleaning

      t.timestamps
    end
  end
end
