class ChangeWhatsappTypeForUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :whatsapp_avaliable, :boolean, :default => false
  end
end
