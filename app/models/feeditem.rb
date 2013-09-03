class Feeditem < ActiveRecord::Base
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy

  attr_accessible :post_title,:post_pub_date,:post_body,:post_url, :feed_id, :id

  validates_uniqueness_of :post_url, :scope => [:feed_id]

  def self.get_feed_list(user_id,feed_id)
    all_post = Feeditem.find_all_by_feed_id(feed_id)
    read_posts = Feeditem.joins(:readfeeditems).where("readfeeditems.user_id = (?) AND readfeeditems.feed_id = (?) ",user_id,feed_id)
    read_posts_ids = read_posts.map{|x| x.id}

    unread_posts = all_post.reject{|x| read_posts_ids.include? x.id}

    ordered_unread_post = unread_posts.sort_by{|h| h.post_pub_date}.reverse!
    ordered_read_post = read_posts.sort_by{|h| h.post_pub_date}.reverse!

    return ordered_unread_post, ordered_read_post
  end

end
