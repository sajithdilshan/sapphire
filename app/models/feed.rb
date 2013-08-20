# require 'rubygems'
# require 'feedzirra'

class Feed < ActiveRecord::Base
  validates_presence_of :feed_url
  attr_accessible :feed_name, :feed_url, :lastread, :category, :userfeed_id, :id
  has_many :userfeed
  has_many :feeditems, :dependent => :destroy
  validates_uniqueness_of :feed_url

  def self.addFeed(f_url, userid)
    #fetching feed from remote server
    fetched_feed = Feedzirra::Feed.fetch_and_parse(f_url)

    # fetch the user entry from "users" model
    user = User.find_by_uid(userid)

    #create and save an entry in "userfeeds" table
    user_feed = Userfeed.create(:user_id => user.uid, :category => "default",:lastread => nil)

    #creates and save feed item to "feeds" table
    feed = Feed.create(:feed_name => fetched_feed.title, :feed_url => fetched_feed.feed_url)
    
    user_feed.feed_id = feed.id
    user_feed.save!

    fetched_feed.entries.each do |entry|
      # creates and saves an entry for each post in "feeditems" table
      f_item = Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => entry.content, :post_url => entry.url)
    end

    
  end


  def self.getUserFeedList(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
  end

end
