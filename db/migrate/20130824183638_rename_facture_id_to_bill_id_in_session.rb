class RenameFactureIdToBillIdInSession < ActiveRecord::Migration
  def up
    rename_column :sessions, :facture_id, :bill_id
  end

  def down
    rename_column :sessions, :bill_id, :facture_id
  end
end
