class AddCountryToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :country, :string
  end
end
