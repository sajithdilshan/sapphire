class CreateUserfeeds < ActiveRecord::Migration
  def up
    create_table :userfeeds do |t|
      t.string :category
      t.string  :user_id
      t.integer :feed_id
      t.timestamps
    end

    add_index :userfeeds, :user_id
    add_index :userfeeds, :feed_id
  end

  def down
    remove_index :userfeeds, :user_id
    remove_index :userfeeds, :feed_id
    drop_table 'userfeeds'
  end
end
