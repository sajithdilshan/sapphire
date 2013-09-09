class FeedsController < ApplicationController

  def create
    @feed = Feed.new(params[:feed])

    feed_url = @feed[:feed_url]
    userid = current_user.uid

    f = Feed.add_feed(feed_url, userid)
    key = f.keys[0]
    flash[key] = f[f.keys[0]]
    redirect_to userfeeds_path
  end

end
