class UpdateFeed < Struct .new(:userid)
  def perform
    Feed.userFeedUpdate(userid)
  end

    def max_attempts
    return 3
  end
end