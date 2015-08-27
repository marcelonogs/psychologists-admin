class RemoveEndDateInSessions < ActiveRecord::Migration
  def up
    remove_column :sessions, :end_date
  end

  def down
    add_column :sessions, :end_date, :date
  end
end
