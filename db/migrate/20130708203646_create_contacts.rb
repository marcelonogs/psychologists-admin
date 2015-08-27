class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.date :birthdate
      t.string :language
      t.string :nationality
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :phone_pro
      t.string :phone_perso
      t.string :phone_mobile
      t.string :civil_status
      t.boolean :is_archived
      t.string :referent
      t.string :rate

      t.timestamps
    end
  end
end
