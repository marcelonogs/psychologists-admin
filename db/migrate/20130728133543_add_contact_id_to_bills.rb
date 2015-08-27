class AddContactIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :contact_id, :integer, default: nil
  end
end
