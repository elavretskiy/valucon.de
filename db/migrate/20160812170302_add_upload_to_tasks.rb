class AddUploadToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :upload, :string
  end
end
