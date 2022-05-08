class CreateConsults < ActiveRecord::Migration[6.0]
  def change
    create_table :consults do |t|
      t.datetime :started_at
      t.datetime :finish_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
