class RemoveRateFromContact < ActiveRecord::Migration
  def up
    remove_column :contacts, :rate
  end

  def down
    add_column :contacts, :rate, :float, precision: 6, scale: 2
  end
end
