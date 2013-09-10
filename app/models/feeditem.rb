class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy
  attr_accessible :post_title, :post_pub_date, :post_body, :post_url, :feed_id, :id
  validates_uniqueness_of :post_url, :scope => [:feed_id]

  # This method query the post list of a feed and sort it to read and unread items
  #
  # * *Args*    :
  #   - +feed_id+ -> id of the feed where the posh list belongs to
  #   - +userid+ -> The user id of the currently logged in user.
  # * *Returns* :
  #   - Two variables, namely read post items and unread post items
  # * *Raises* :
  #   None
  #
  def self.get_read_post_list(user_id, feed_id, limit, offset)
    Feeditem.joins(:readfeeditems).where('readfeeditems.user_id = (?) AND readfeeditems.feed_id = (?) ', user_id,
                                         feed_id).order('post_pub_date DESC').limit(limit).offset(offset.to_i*
                                                                                                      limit.to_i)
  end

  def self.get_unread_post_list(user_id, feed_id, limit, offset)
    statement = "LEFT OUTER JOIN readfeeditems ON readfeeditems.feeditem_id=feeditems.id and readfeeditems.user_id =#{user_id.to_s}"
    Feeditem.joins(statement).where('readfeeditems.id is null and feeditems.feed_id=(?)',
                                    feed_id).order('post_pub_date DESC').limit(limit).offset(offset.to_i*
                                                                                                 limit.to_i)
  end

  def self.get_all_posts(user_id, feed_id, limit, offset)
    return Feeditem.get_read_post_list(user_id, feed_id, limit, offset), Feeditem.get_unread_post_list(user_id,
                                                                                                       feed_id, limit,
                                                                                                       offset)
  end
end
