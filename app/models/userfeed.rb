class Userfeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  has_many :readfeeditems, :dependent => :destroy
  attr_accessible :category, :user_id, :id, :feed_id

  # This method returns the userfeeds entries and corresponding feeds entries for a particular user.
  #
  # * *Args*    :
  #   - +user_id+  -> id of the currently logged in user
  # * *Returns* :
  #   - userfeeds list and feeds list.
  # * *Raises* :
  #   None
  #
  def self.get_userfeed_with_feed(user_id)
    return Userfeed.where('user_id' => user_id), Feed.unordered_feed_list(user_id)
  end
end
