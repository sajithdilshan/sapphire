class CreateReadfeeditems < ActiveRecord::Migration
  def up
    create_table :readfeeditems do |t|
      t.string :user_id
      t.integer :feed_id
      t.integer :feeditem_id
      t.timestamps
    end
    add_index :readfeeditems, :user_id
    add_index :readfeeditems, :feed_id
  end
  def down
    remove_index :readfeeditems, :user_id
    remove_index :readfeeditems, :feed_id
    drop_table 'readfeeditems'
  end
end
