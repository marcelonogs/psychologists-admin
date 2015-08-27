class AddBillingTitleToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :billing_title, :string
    add_column :contacts, :billing_street, :string
    add_column :contacts, :billing_zipcode, :string
    add_column :contacts, :billing_city, :string
    add_column :contacts, :billing_country, :string
  end
end
