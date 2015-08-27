class AddPhoneMobile2ToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :phone_mobile_2, :string
  end
end
