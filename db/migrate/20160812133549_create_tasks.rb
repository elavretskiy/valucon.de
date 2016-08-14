class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :description
      t.string :state, null: false
      t.belongs_to :user

      t.timestamps null: false
    end

    add_index :tasks, :name
    add_index :tasks, :description
    add_index :tasks, :state
  end
end
