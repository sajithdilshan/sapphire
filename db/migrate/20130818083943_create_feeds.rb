class CreateFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.string :feed_name
      t.string :feed_url
      t.timestamps
    end
  end

  def down
    drop_table 'feeds'
  end
end
