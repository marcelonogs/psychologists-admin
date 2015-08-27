class AddBillCreationFieldsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :bill_every_x_sessions, :integer, default: 10
    add_column :contacts, :is_bill_every_month, :boolean
  end
end
