class CreateUserfeeds < ActiveRecord::Migration
  def up
    create_table :userfeeds do |t|
      t.string :category
      t.datetime :lastread
      t.string  :user_id
      t.integer :feed_id
      t.timestamps
    end
  end

  def down
    drop_table 'userfeeds'
  end
end
