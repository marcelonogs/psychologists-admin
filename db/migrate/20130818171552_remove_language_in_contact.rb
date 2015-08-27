class RemoveLanguageInContact < ActiveRecord::Migration
  def up
    remove_column :contacts, :language
  end

  def down
    add_column :contacts, :language, :string
  end
end
