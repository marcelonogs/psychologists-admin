class AddRateCotherapyToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :rate_cotherapy, :float, precision: 6, scale: 2
  end
end
