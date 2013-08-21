class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :unreadfeeditems, :dependent => :destroy

  attr_accessible :post_title,:post_pub_date,:post_body,:post_url, :feed_id, :id

  def self.get_feed_list(user_id,feed_id)
    Feeditem.joins(:unreadfeeditems).where("unreadfeeditems.user_id = (?) AND unreadfeeditems.feed_id = (?) ",user_id,feed_id).order("post_pub_date DESC")
    # Feeditem.find_all_by_feed_id(feed_id)
  end

end
