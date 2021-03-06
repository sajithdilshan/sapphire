class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :provider
      t.string :uid, :null => false
      t.string :name
      t.string :profile_pic
      t.string :refresh_token
      t.string :access_token
      t.timestamp :expires
      t.timestamps
    end
    add_index :users, :uid
  end

  def down
    remove_index :users, :uid
    drop_table 'users'
  end
  
end
