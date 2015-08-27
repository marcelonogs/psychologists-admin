class AddStatusToBill < ActiveRecord::Migration
  def change
    add_column :bills, :status, :string, default: "draft"
  end
end
