class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
