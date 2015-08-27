class ChangeBillEveryXSessionsInContacts < ActiveRecord::Migration
  def up
    change_column :contacts, :bill_every_x_sessions, :integer, default: 6
  end

  def down
    change_column :contacts, :bill_every_x_sessions, :integer, default: 10
  end
end
