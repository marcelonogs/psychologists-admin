class ChangeBirthdateInContacts < ActiveRecord::Migration
  def up
    change_column :contacts, :birthdate, :string
  end

  def down
    change_column :contacts, :birthdate, :date
  end
end
