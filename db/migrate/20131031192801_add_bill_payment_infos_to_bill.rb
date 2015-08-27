class AddBillPaymentInfosToBill < ActiveRecord::Migration
  def change
    add_column :bills, :sent_on, :date
    add_column :bills, :paid_on, :date
    add_column :bills, :recall_sent_on, :date
    add_column :bills, :notes, :text
  end
end
