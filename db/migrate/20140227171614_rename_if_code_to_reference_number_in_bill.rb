class RenameIfCodeToReferenceNumberInBill < ActiveRecord::Migration
  def up
    rename_column :bills, :if_code, :reference_number
  end

  def down
    rename_column :bills, :reference_number, :if_code
  end
end
