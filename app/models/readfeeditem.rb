class Readfeeditem < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  belongs_to :feeditem

  validates_uniqueness_of :feeditem_id, :scope => [:user_id,:feed_id]
  attr_accessible :feed_id, :feeditem_id, :user_id

  def self.mark_as_viewed(user, feed_id,post_id)
      Readfeeditem.create(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)   
  end

  def self.mark_as_unread(user,feed_id,post_id)
    Readfeeditem.delete_all(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)
  end

end

