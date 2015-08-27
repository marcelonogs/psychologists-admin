class ChangeStartDatetimeToStartDateInSessions < ActiveRecord::Migration
  def up
    change_column :sessions, :start_date, :date
  end

  def down
    change_column :sessions, :start_date, :datetime
  end
end
