class UserfeedsController < ApplicationController
  before_filter :prepare_userfeed_form, only: [:index]

  def prepare_userfeed_form
    @feed = Feed.new
    @feeditems = Feed.ordered_feed_list(current_user.uid)
  end

  def refresh_feed_list
    Delayed::Job.enqueue UpdateFeed.new(current_user.uid)
    @ajax_status = 'Updating all feeds in the background...'
    respond_to do |format|
      format.js { render 'shared/ajax-progress' }
    end

  end

  def remove_feed
    @userfeed_all, @feedlist_unordered = Userfeed.get_userfeed_with_feed(current_user.uid)
  end

  def show_feed_list
    feed_id = params[:feed_id]
    @readfeeditem_list, @feeditem_list = Feeditem.get_all_posts(current_user.uid, feed_id,5,0)
    @feed_id = feed_id

    if @feeditem_list.nil? and @readfeeditem_list.nil?
      @ajax_status = 'Error occured while fetching post list. Please try again...'
    end

    respond_to do |format|
      format.js
    end

  end

  def get_unread_posts
    offset = params[:read_page]
    @feed_id = params[:feed_id]
    @unread_posts = Feeditem.get_unread_post_list(current_user.uid,@feed_id,5,offset)

  end

  def get_read_posts
    offset = params[:read_page]
    @feed_id = params[:feed_id]
    @read_posts = Feeditem.get_read_post_list(current_user.uid,@feed_id,5,offset)

  end


  def mark_feed_viewed
    feed_id = params[:feed_id]
    post_id = params[:post_id]
    @ajax_status = Readfeeditem.mark_as_viewed(current_user.uid, feed_id,post_id)
    respond_to do |format|
      format.js  {render 'shared/ajax-progress'}
    end

  end

  def mark_feed_unread
    feed_id = params[:feed_id]
    post_id = params[:post_id]
    @ajax_status = Readfeeditem.mark_as_unread(current_user.uid,feed_id,post_id)
  end


  def index

  end

  def destroy
    @userfeed = Userfeed.find(params[:id])
    if @userfeed.destroy
      flash[:notice] = 'Feed removed successfully'
    else
      flash[:alert] = 'An error occured while removing the feed. Please try again.'
    end
    redirect_to remove_feed_path
  end
end
