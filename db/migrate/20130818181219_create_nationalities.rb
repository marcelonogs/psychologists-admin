class CreateNationalities < ActiveRecord::Migration
  def change
    create_table :nationalities do |t|
      t.string :name
      t.integer :contact_id

      t.timestamps
    end
  end
end
