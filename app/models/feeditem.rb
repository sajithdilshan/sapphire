class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy

  attr_accessible :post_title,:post_pub_date,:post_body,:post_url, :feed_id, :id

  validates_uniqueness_of :post_url, :scope => [:feed_id]

  def self.get_feed_list(user_id,feed_id)
    all = Feeditem.find_all_by_feed_id(feed_id)
    read_posts = Feeditem.joins(:readfeeditems).where("readfeeditems.user_id = (?) AND readfeeditems.feed_id = (?) ",user_id,feed_id).order("post_pub_date DESC")
    read_posts_ids = read_posts.map{|x| x.id}

    unread_posts = all.reject{|x| read_posts_ids.include? x.id}
    # puts read.first.id
    # # Feeditem.find_all_by_feed_id(feed_id)
    # puts  read.first.id
    return unread_posts, read_posts
  end

end
