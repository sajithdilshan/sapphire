# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130821072644) do

  create_table "feeditems", :force => true do |t|
    t.string   "post_title"
    t.datetime "post_pub_date"
    t.string   "post_body"
    t.string   "post_url"
    t.integer  "feed_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feeditems", ["feed_id"], :name => "index_feeditems_on_feed_id"

  create_table "feeds", :force => true do |t|
    t.string   "feed_name"
    t.string   "feed_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "readfeeditems", :force => true do |t|
    t.string   "user_id"
    t.integer  "feed_id"
    t.integer  "feeditem_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "readfeeditems", ["feed_id"], :name => "index_readfeeditems_on_feed_id"
  add_index "readfeeditems", ["user_id"], :name => "index_readfeeditems_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "userfeeds", :force => true do |t|
    t.string   "category"
    t.datetime "lastread"
    t.string   "user_id"
    t.integer  "feed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "userfeeds", ["feed_id"], :name => "index_userfeeds_on_feed_id"
  add_index "userfeeds", ["user_id"], :name => "index_userfeeds_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid",           :null => false
    t.string   "name"
    t.string   "profile_pic"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
