class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.date :start_date
      t.date :end_date
      t.integer :facture_id, default: nil
      t.integer :serie_id

      t.timestamps
    end
  end
end
