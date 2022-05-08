class ChangeDataTypeForUsers < ActiveRecord::Migration[6.0]
    def up
      change_column :users, :phone, :bigint
    end
  
    def down
      change_column :users, :phone, :integer
    end
  
end
