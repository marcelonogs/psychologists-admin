class AddIsCotherapyToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :is_cotherapy, :boolean, default: false
  end
end
