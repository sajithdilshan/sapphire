class Feed < ActiveRecord::Base
  validates_presence_of :feed_url
  attr_accessible :feed_name, :feed_url, :lastread, :category, :userfeed_id, :id
  has_many :userfeed
  has_many :readfeeditems, :dependent => :destroy
  has_many :feeditems, :dependent => :destroy
  validates_uniqueness_of :feed_url

  def self.userFeedUpdate(userid)
    puts "performing the userfeed update of " + userid
    #querying the list of feeds of the user
    feeds = Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
    #populating a list of feedid and url tuples
    feed_id_list =[]
    feeds.entries.each do |entry|
      feed_id_list.append([entry.id,entry.feed_url])
    end

    feed_id_list.each do |id, url|
      #querying the published date of the recent post item
      last_entry = Feeditem.where("feed_id" => id).first["post_pub_date"].to_time
      #fetching the feed
      fetched_feed = Feedzirra::Feed.fetch_and_parse(url)
      #if fetching feed is sucessful
      unless fetched_feed.nil?
        fetched_feed.entries.each do |entry|
          postbody = ""
          # some feeds puts description in content and others put it in content
          if entry.content.nil?
            postbody = entry.summary
          else
            postbody = entry.content
          end
          #if there are new post, they will be added to Feeditem table
          if entry.published.to_time > last_entry
            f_item = Feeditem.create(:feed_id => id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => postbody, :post_url => entry.url)
          end
        end   #end of fetched_feed loop
      end   #end of unless clause
    end   #end of feed_id_list loop
  end   #end of userfeedupdate


  def self.addFeed(f_url, userid)
    #fetching feed from remote server    
    fetched_feed = Feedzirra::Feed.fetch_and_parse(f_url)   
    #error occured fetching feed
    if fetched_feed.nil?
      return false
    #after successfully fetching feed
    else
      is_feed_exisits = Feed.find_by_feed_url(fetched_feed.feed_url)
      if is_feed_exisits
        is_userfeed_exist = Userfeed.where(:user_id => userid, :feed_id => is_feed_exisits.id )
        if !is_userfeed_exist.nil?
          return true
        end
      end
      user = User.find_by_uid(userid)
      user_feed = Userfeed.create(:user_id => user.uid, :category => "default",:lastread => nil)

      
      if is_feed_exisits.nil?
        
        feed = Feed.create(:feed_name => fetched_feed.title, :feed_url => fetched_feed.feed_url)

        fetched_feed.entries.each do |entry|
          postbody = ""
          if entry.content.nil?
            postbody = entry.summary
          else
            postbody = entry.content
          end
          f_item = Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => postbody, :post_url => entry.url)
        end

      else
        feed = is_feed_exisits
      end

      user_feed.feed_id = feed.id
      user_feed.save!

    end   #end of fetchedfeed.nil?
  end   #end of addfeed method

  def self.getUserFeedList(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid).order("feed_name ASC")
  end

  def self.getfeedlistUnordered(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
  end

end
