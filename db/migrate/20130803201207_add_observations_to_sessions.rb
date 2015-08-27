class AddObservationsToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :observations, :string
  end
end
