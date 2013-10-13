class FeedsController < ApplicationController

  def create
    feed = params[:feed]

    feed_url = feed[:feed_url]
    category = feed[:category]
    userid = current_user.uid

    returned_message_hash = Feed.add_feed(feed_url, userid,category)
    message_type = returned_message_hash.keys[0]
    flash[message_type] = returned_message_hash[message_type]

    redirect_to userfeeds_path
  end

end
