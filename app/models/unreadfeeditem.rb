class Unreadfeeditem < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user
  belongs_to :feeditem

  
  attr_accessible :feed_id, :feeditem_id, :user_id

  def self.mark_as_viewed(user, feed_id,post_id)
    q = Unreadfeeditem.where(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)
    if q.nil?
      return
    else
      Unreadfeeditem.destroy(q.first.id)
    end
  end

  def self.mark_as_unread(user,feed_id,post_id)
    Unreadfeeditem.create(:user_id => user, :feed_id => feed_id, :feeditem_id => post_id)
  end

end

