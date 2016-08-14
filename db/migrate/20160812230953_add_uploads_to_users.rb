class AddUploadsToUsers < ActiveRecord::Migration
  def change
    remove_column :tasks, :upload
    add_column :tasks, :uploads, :string, array: true, default: []
  end
end
