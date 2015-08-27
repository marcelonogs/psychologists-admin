class AddBillingContactToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :billing_firstname, :string
    add_column :contacts, :billing_lastname, :string
    add_column :contacts, :billing_address, :string
    add_column :contacts, :is_billing_contact, :boolean
  end
end
