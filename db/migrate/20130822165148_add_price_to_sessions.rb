class AddPriceToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :price, :float, precision: 6, scale: 2
  end
end
