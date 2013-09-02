class Readfeeditem < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  belongs_to :feeditem
  belongs_to :userfeed


  validates_uniqueness_of :feeditem_id, :scope => [:user_id,:feed_id]
  attr_accessible :feed_id, :feeditem_id, :user_id, :userfeed_id

  def self.mark_as_viewed(user, feed_id,post_id)
      u_feed = Userfeed.where(:user_id => user, :feed_id => feed_id)
      Readfeeditem.create(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id, :userfeed_id => u_feed.first.id )   
  end

  def self.mark_as_unread(user,feed_id,post_id)
    Readfeeditem.delete_all(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)
  end

end

