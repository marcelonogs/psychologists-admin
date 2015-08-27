class AddRatesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :rate_30, :float, precision: 6, scale: 2, default: 110.00
    add_column :contacts, :rate_45, :float, precision: 6, scale: 2, default: 165.00
    add_column :contacts, :rate_60, :float, precision: 6, scale: 2, default: 220.00
  end
end
