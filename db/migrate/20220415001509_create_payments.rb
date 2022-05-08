class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string  :method
      t.date :date
      t.references :consult, null: false, foreign_key: true

      t.timestamps
    end
  end
end
