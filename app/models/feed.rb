require 'time'

class Feed < ActiveRecord::Base
  validates_presence_of :feed_url
  attr_accessible :feed_name, :feed_url, :id
  has_many :userfeed, :dependent => :destroy
  has_many :readfeeditems, :dependent => :destroy
  has_many :feeditems, :dependent => :destroy
  validates_uniqueness_of :feed_url

  # This method updates the feed list of a particular user by fetching new posts
  #
  # * *Args*    :
  #   - +userid+ -> The user id of the currently logged in user.
  # * *Returns* :
  #   - nil if user has no feeds.
  # * *Raises* :
  #   None
  #
  def self.update_user_feeds(userid)
    Rails.logger.info "performing the userfeed update of #{userid.to_s}"
    #querying the list of feeds of the user
    feeds = Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
    return true if feeds.nil?

    #populating a list of feedid and url tuples
    feed_id_list =[]

    feeds.entries.each do |entry|
      feed_id_list.append([entry.id, entry.feed_url])
    end

    feed_id_list.each do |id, url|
      #querying the published date of the recent post item
      last_entry = Feeditem.where('feed_id' => id).first.post_pub_date
      #fetching the feed
      fetched_feed = Feedzirra::Feed.fetch_and_parse(url)
      #if fetching feed is sucessful
      unless fetched_feed.nil?
        fetched_feed.entries.each do |entry|
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
  def self.add_feed(f_url, userid)
    #fetching feed from remote server 
    feed_exist = Feed.find_by_feed_url(f_url)
    if feed_exist.nil? 
      fetched_feed = Feedzirra::Feed.fetch_and_parse(f_url)  
    else
      fetched_feed = feed_exist
    end

    if fetched_feed.nil?
      return {alert: 'Error occured while fetching feed. Please try again later.'}
    else
      # is_feed_exisits = check_if_feed_exists_by_feed_url(fetched_feed.feed_url)
      if feed_exist
        userfeed_exist = Userfeed.find_by_user_id_and_feed_id(userid, feed_exist.id )
        unless userfeed_exist.nil?
          return {notice: 'You have already added that feed'}
        end
        feed = feed_exist
      else

        feed = Feed.create(:feed_name => fetched_feed.title, :feed_url => fetched_feed.feed_url)
        if feed.nil?
          return {alert: 'Error occured while creating feed. Please try again later.'}
        end

        fetched_feed.entries.each do |entry|
          if entry.content.nil?
            postbody = entry.summary.html_safe
          else
            postbody = entry.content.html_safe
          end
          Feeditem.create(:feed_id => feed.id, :post_title => entry.title, :post_pub_date => entry.published, :post_body => postbody, :post_url => entry.url)
        end

      end
      
      user = User.find_by_uid(userid)
      Userfeed.create(:user_id => user.uid, :category => 'default',:lastread => nil, :feed_id => feed.id)

      return {notice: 'Feed added Successfully'}
    end   #end of fetchedfeed.nil?
  end   #end of addfeed method

  # This method queries the subscriptions(feeds) for a given user (ordered)
  #
  # * *Args*    :
  #   - +userid+ -> The user id of the currently logged in user.
  # * *Returns* :
  #   - Array of Feeds, if any in the ascending order of the feed_name attribute
  # * *Raises* :
  #   None
  #
  def self.ordered_feed_list(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid).order('feed_name ASC')
  end

  # This method queries the subscriptions(feeds) for a given user (unordered)
  #
  # * *Args*    :
  #   - +userid+ -> The user id of the currently logged in user.
  # * *Returns* :
  #   - Array of Feeds, if any in particularly no order
  # * *Raises* :
  #   None
  #
  def self.unordered_feed_list(userid)
    Feed.joins(:userfeed).where('userfeeds.user_id' => userid)
  end

end
