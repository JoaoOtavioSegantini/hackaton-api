class AddRoomFeaturesReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :room_features, :room, foreign_key: true
  end
end
