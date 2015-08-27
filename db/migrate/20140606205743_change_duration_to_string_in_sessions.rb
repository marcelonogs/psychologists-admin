class ChangeDurationToStringInSessions < ActiveRecord::Migration
  def up
    change_column :sessions, :duration, :string
  end

  def down
    change_column :sessions, :duration, :integer
  end
end
