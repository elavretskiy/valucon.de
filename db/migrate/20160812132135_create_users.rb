class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, unique: true, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 1

      t.timestamps null: false
    end

    add_index :users, :email
  end
end
