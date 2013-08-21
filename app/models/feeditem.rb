class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :unreadfeeditems, :dependent => :destroy

  attr_accessible :post_title,:post_pub_date,:post_body,:post_url, :feed_id, :id

  def self.get_feed_list(user_id,feed_id)
    all = Feeditem.find_all_by_feed_id(feed_id)
    unread = Feeditem.joins(:unreadfeeditems).where("unreadfeeditems.user_id = (?) AND unreadfeeditems.feed_id = (?) ",user_id,feed_id).order("post_pub_date DESC")
    unread_ids = unread.map{|x| x.id}

    read = all.reject{|x| unread_ids.include? x.id}
    # puts read.first.id
    # # Feeditem.find_all_by_feed_id(feed_id)
    # puts  read.first.id
    return unread, read
  end

end
