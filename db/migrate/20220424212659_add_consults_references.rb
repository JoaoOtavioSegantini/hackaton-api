class AddConsultsReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :consults, :room_rent, foreign_key: true
  end
end
