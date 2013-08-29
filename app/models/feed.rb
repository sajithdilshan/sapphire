class Feed < ActiveRecord::Base
  validates_presence_of :feed_url
  attr_accessible :feed_name, :feed_url, :lastread, :category, :userfeed_id, :id
  has_many :userfeed
  has_many :readfeeditems, :dependent => :destroy
  has_many :feeditems, :dependent => :destroy
  validates_uniqueness_of :feed_url

  def self.globalFeedUpdate
    feeds = Feed.all
    feed_id_list =[]
    feeds.entries.each do |entry|
      feed_id_list.append([entry.id,entry.feed_url])
    end

    feed_id_list.each do |id, url|
       last_entry = Feeditem.where("feed_id" => id).first["post_pub_date"].to_time
       fetched_feed = Feedzirra::Feed.fetch_and_parse(url,:if_modified_since => last_entry)

       unless fetched_feed.nil?
        fetched_feed.entries.each do |entry|
          f_item = Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => entry.content, :post_url => entry.url)
        end
      end

    end

  end

  def self.addFeed(f_url, userid)
    #fetching feed from remote server
    fetched_feed = Feedzirra::Feed.fetch_and_parse(f_url)

    user = User.find_by_uid(userid)
    user_feed = Userfeed.create(:user_id => user.uid, :category => "default",:lastread => nil)

    is_feed_exisits = Feed.find_by_feed_url(fetched_feed.feed_url)
    if is_feed_exisits.nil?
      feed = Feed.create(:feed_name => fetched_feed.title, :feed_url => fetched_feed.feed_url)

      fetched_feed.entries.each do |entry|
        f_item = Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => entry.content, :post_url => entry.url)
      end

    else
      feed = is_feed_exisits
    end

    user_feed.feed_id = feed.id
    user_feed.save!

    
  end

  def self.getUserFeedList(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
  end

end
