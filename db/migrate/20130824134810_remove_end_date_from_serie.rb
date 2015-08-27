class RemoveEndDateFromSerie < ActiveRecord::Migration
  def up
    remove_column :series, :end_date
  end

  def down
    add_column :series, :end_date, :date
  end
end
