class CreateRoomRents < ActiveRecord::Migration[6.0]
  def change
    create_table :room_rents do |t|
      t.date :started_at
      t.date :finish_at
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
