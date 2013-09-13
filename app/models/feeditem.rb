class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy
  attr_accessible :post_title, :post_pub_date, :post_body, :post_url, :feed_id, :id
  validates_uniqueness_of :post_url, :scope => [:feed_id]

  # This method returns the viewed feeditems (posts) of a feed for a particular user.
  #
  # * *Args*    :
  #   - +feed_id+ -> id of the feed where the feeditems belong to
  #   - +user_id+  -> The id of the currently logged in user
  #   - +limit+   -> Number of feeditems to return (e:g. 10 )
  #   - +offset+  -> Starting postition of the returned results (e:g limit of 12 and offset of 3 will return results
  # from 36th (3*12) item onwards excluding 36th item)
  # * *Returns* :
  #   - List of Feeditems or nil.
  # * *Raises* :
  #   None
  #
  def self.get_read_post_list(user_id, feed_id, limit, offset)
    Feeditem.joins(:readfeeditems).where('readfeeditems.user_id = (?) AND readfeeditems.feed_id = (?) ', user_id,
                                         feed_id).order('post_pub_date DESC').limit(limit).offset(offset.to_i*
                                                                                                      limit.to_i)
  end

  # This method returns the unviewed feeditems (posts) of a feed for a particular user.
  #
  # * *Args*    :
  #   - +feed_id+ -> id of the feed where the feeditems belong to
  #   - +user_id+  -> The id of the currently logged in user
  #   - +limit+   -> Number of feeditems to return (e:g. 10 )
  #   - +offset+  -> Starting postition of the returned results (e:g limit of 12 and offset of 3 will return results
  # from 36th (3*12) item onwards excluding 36th item)
  # * *Returns* :
  #   - List of Feeditems or nil.
  # * *Raises* :
  #   None
  #
  def self.get_unread_post_list(user_id, feed_id, limit, offset)
    statement = "LEFT OUTER JOIN readfeeditems ON readfeeditems.feeditem_id=feeditems.id and readfeeditems.user_id =#{user_id.to_s}"
    Feeditem.joins(statement).where('readfeeditems.id is null and feeditems.feed_id=(?)',
                                    feed_id).order('post_pub_date DESC').limit(limit).offset(offset.to_i*
                                                                                                 limit.to_i)
  end

  # This method returns the number of unviewed feeditems (posts) of all the feeds for a particular user.
  #
  # * *Args*    :
  #   - +user_id+  -> The id of the currently logged in user
  # * *Returns* :
  #   - Hash with the feed id as the key and number of unread posts count as the value.
  # * *Raises* :
  #   None
  #
  def self.get_unread_post_count(user_id)
    statement = "LEFT OUTER JOIN readfeeditems ON readfeeditems.feeditem_id=feeditems.id and readfeeditems.user_id =#{user_id.to_s}"
    Feeditem.joins(statement).where('readfeeditems.id is null').group('feeditems.feed_id').count()
  end

  # This method returns viewed feeditems and unviewed feeditems of a feed for a particular user.
  #
  # * *Args*    :
  #   - +feed_id+ -> id of the feed where the feeditems belong to
  #   - +user_id+ -> The id of the currently logged in user
  #   - +limit+   -> Number of feeditems to return (e:g. 10 )
  #   - +offset+  -> Starting postition of the returned results (e:g limit of 12 and offset of 3 will return results
  # from 36th (3*12) item onwards excluding 36th item)
  # * *Returns* :
  #   - Two lists of feeditems. Unread feeditems and Read feeditems.l
  # * *Raises* :
  #   None
  #
  def self.get_all_posts(user_id, feed_id, limit, offset)
    return Feeditem.get_read_post_list(user_id, feed_id, limit, offset), Feeditem.get_unread_post_list(user_id,
                                                                                                       feed_id, limit,
                                                                                                       offset)
  end
end
