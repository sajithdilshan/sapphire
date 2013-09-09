class Userfeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy
  attr_accessible :category, :lastread, :user_id, :id, :feed_id

  def self.get_userfeed_with_feed(user_id)
    return Userfeed.where('user_id' => user_id), Feed.unordered_feed_list(user_id)
  end
end
