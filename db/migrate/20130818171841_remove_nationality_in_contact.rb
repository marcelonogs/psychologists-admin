class RemoveNationalityInContact < ActiveRecord::Migration
  def up
    remove_column :contacts, :nationality
  end

  def down
    add_column :contacts, :nationality, :string
  end
end
