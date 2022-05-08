class ChangeDataTypeForBooks < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :accepted
    add_column  :books, :accepted, :integer, :default => 0
  end
end
