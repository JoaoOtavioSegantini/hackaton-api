class ChangeDataTypeForRoom < ActiveRecord::Migration[6.0]
    def up
      remove_column :rooms, :description
    end
   
    def down
      add_column :rooms, :description, :text
    end
end
