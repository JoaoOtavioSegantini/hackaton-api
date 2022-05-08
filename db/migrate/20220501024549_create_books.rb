class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.boolean :admin, default: false
      t.boolean :accepted, default: false
      t.bigint :recepient_id

      t.timestamps
    end
  end
end
