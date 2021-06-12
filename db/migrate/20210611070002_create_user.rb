class CreateUser < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :password, null: false
      t.integer :access_failed_count, default: 0
      t.datetime :access_locked_at, index: true

      t.timestamps
    end
  end
end
