class AddIndexForUserIdInTasks < ActiveRecord::Migration
  def change
    add_index :tasks, :user_id
  end
end
