class AddBureauToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :bureau, :string
  end
end
