class Readfeeditem < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  belongs_to :feeditem
  belongs_to :userfeed

  validates_uniqueness_of :feeditem_id, :scope => [:user_id,:feed_id]
  attr_accessible :feed_id, :feeditem_id, :user_id, :userfeed_id

  # This method marks a post item as viewed one.
  #
  # * *Args*    :
  #   - +user+ -> user id of the currentlyy logged in user.
  #   - +feed_id+ -> id of the feed where the post item belongs.
  #   - +post_id+ -> id of the post item which should be marked as viewed
  # * *Returns* :
  #   - An error is action fails, otherwise returns nil
  # * *Raises* :
  #   - None
  #
  def self.mark_as_viewed(user, feed_id,post_id)
    u_feed = Userfeed.find_by_user_id_and_feed_id(user,feed_id)
    new_item = Readfeeditem.create(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id, :userfeed_id => u_feed.id )   
    if new_item.nil?
      Rails.logger.debug "Error occured while marking post as viewed =>"+"user:"+user.to_s+" feed:"+feed_id.to_s+" post:"+post_id.to_s
      return "Error occured while marking post as viewed"
    else 
      return nil
    end
  end

  # This method marks a post item as not viewed one.
  #
  # * *Args*    :
  #   - +user+ -> user id of the currentlyy logged in user.
  #   - +feed_id+ -> id of the feed where the post item belongs.
  #   - +post_id+ -> id of the post item which should be marked as unread
  # * *Returns* :
  #   - An error is action fails, otherwise returns nil
  # * *Raises* :
  #   - None
  #
  def self.mark_as_unread(user,feed_id,post_id)
    delete_item = Readfeeditem.delete_all(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)
    if delete_item.nil?
      Rails.logger.debug "Error occured while marking post as unread. =>"+"user:"+user.to_s+" feed:"+feed_id.to_s+" post:"+post_id.to_s
      return "Error occured while marking post as unread."
    else
      return nil
    end
  end

end

