class CreateFeeditems < ActiveRecord::Migration
 def up
    create_table :feeditems do |t|
      t.string :post_title
      t.datetime :post_pub_date
      t.string :post_body
      t.string :post_url
      t.integer :feed_id
      t.timestamps
    end
  end

  def down 
    drop_table 'feeditems'
  end
end
