class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :if_code
      t.string :payment_status

      t.timestamps
    end
  end
end
