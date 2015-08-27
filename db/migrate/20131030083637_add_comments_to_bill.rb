class AddCommentsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :comments, :text
  end
end
