class ChangeDateToDatetimeInSessions < ActiveRecord::Migration
  def up
  	change_column :sessions, :start_date, :datetime
  	change_column :sessions, :end_date, :datetime
  end

  def down
	change_column :sessions, :start_date, :date
  	change_column :sessions, :end_date, :date
  end
end
