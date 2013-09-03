class Feed < ActiveRecord::Base
  validates_presence_of :feed_url
  attr_accessible :feed_name, :feed_url, :lastread, :category, :userfeed_id, :id
  has_many :userfeeds, :dependent => :destroy
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
            Feeditem.create(:feed_id => id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => postbody, :post_url => entry.url)
          end
        end   #end of fetched_feed loop
      end   #end of unless clause
    end   #end of feed_id_list loop
  end   #end of userfeedupdate


  # This method adds new feeds to the application. If the feed already exists, it just creates a reference to the user.
  #
  # * *Args*    :
  #   - +f_url+ -> The url of the feed. This can be a link to xml file.
  #   - +userid+ -> The user id of the currently logged in user.
  # * *Returns* :
  #   - Errors if fetching feed or creation Feed table entry fail. Returns a notice if user tries to add duplicate feed. Otherwise will return a success message
  # * *Raises* :
  #   None
  #
  def self.addFeed(f_url, userid)
    #fetching feed from remote server    
    fetched_feed = Feedzirra::Feed.fetch_and_parse(f_url)   

    if fetched_feed.nil?
      return {alert: "Error occured while fetching feed. Please try again later."}
    else
      is_feed_exisits = Feed.find_by_feed_url(fetched_feed.feed_url)
      if is_feed_exisits
        is_userfeed_exist = Userfeed.find_by_user_id_and_feed_id(userid, is_feed_exisits.id )
        unless is_userfeed_exist.nil?
          return {notice: "You have already added that feed"}
        end
        feed = is_feed_exisits
      else

        feed = Feed.create(:feed_name => fetched_feed.title, :feed_url => fetched_feed.feed_url)
        if feed.nil?
          return {alert: "Error occured while creating feed. Please try again later."}
        end

        fetched_feed.entries.each do |entry|
          postbody = ""
          if entry.content.nil?
            postbody = entry.summary
          else
            postbody = entry.content
          end
          Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => postbody, :post_url => entry.url)
        end

      end
      
      user = User.find_by_uid(userid)
      Userfeed.create(:user_id => user.uid, :category => "default",:lastread => nil, :feed_id => feed.id)

      return {notice: "Feed added Successfully"}
    end   #end of fetchedfeed.nil?
  end   #end of addfeed method

  def self.getUserFeedList(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid).order("feed_name ASC")
  end

  def self.getfeedlistUnordered(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
  end

end
