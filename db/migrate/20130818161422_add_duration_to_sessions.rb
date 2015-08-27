class AddDurationToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :duration, :integer
  end
end
