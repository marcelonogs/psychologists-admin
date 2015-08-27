class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.date :start_date
      t.date :end_date
      t.integer :contact_id

      t.timestamps
    end
  end
end
