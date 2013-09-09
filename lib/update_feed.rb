class UpdateFeed < Struct .new(:userid)
  def perform
    Feed.update_user_feeds(userid)
  end

  def max_attempts
     3
  end
end