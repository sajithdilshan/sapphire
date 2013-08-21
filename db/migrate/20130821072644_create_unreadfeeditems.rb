class CreateUnreadfeeditems < ActiveRecord::Migration
  def up
    create_table :unreadfeeditems do |t|
      t.string :user_id
      t.integer :feed_id
      t.integer :feeditem_id
      t.timestamps
    end
    add_index :unreadfeeditems, :user_id
    add_index :unreadfeeditems, :feed_id
  end
  def down
    remove_index :unreadfeeditems, :user_id
    remove_index :unreadfeeditems, :feed_id
    drop_table 'unreadfeeditems'
  end
end
