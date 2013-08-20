class Feeditem < ActiveRecord::Base
  belongs_to :feed
  attr_accessible :post_title,:post_pub_date,:post_body,:post_url, :feed_id, :id

  def self.get_feed_list(feed_id)
    Feeditem.find_all_by_feed_id(feed_id)

  end

end
