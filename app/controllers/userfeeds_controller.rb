class UserfeedsController < ApplicationController
  before_filter :login_required
  before_filter :prepare_userfeed_form, only: [:index]

  def prepare_userfeed_form
    @feed = Feed.new
    @feeditems = Feed.getUserFeedList(current_user.uid)
    # Feed.userFeedUpdate(@feeditems)
  end
  # GET /userfeeds
  # GET /userfeeds.json
  def refresh_feed_list
    Delayed::Job.enqueue UpdateFeed.new(current_user.uid)
    @ajax_status = "Updating all feeds in the backgroung..." 
    respond_to do |format|
      format.js  {render 'shared/ajax-progress'}
    end

  end

  def show_feed_list
    feed_id = params[:feed_id]
    @feeditem_list, @readfeeditem_list = Feeditem.get_feed_list(current_user.uid,feed_id)
    @feed_id = feed_id
    if @feeditem_list.nil? and @readfeeditem_list.nil?
      @ajax_status = "Error occured while fetching post list. Please try again..."
    end
    respond_to do |format|
      format.js   # show_feed_list.js.haml
    end

  end

  def mark_feed_viewed
    feed_id = params[:feed_id]
    post_id = params[:post_id]
    Readfeeditem.mark_as_viewed(current_user.uid, feed_id,post_id)
    respond_to do |format|
      # format.js   # show_feed_list.js.haml
    end

  end

  def mark_feed_unread
    feed_id = params[:feed_id]
    post_id = params[:post_id]
    Readfeeditem.mark_as_unread(current_user.uid,feed_id,post_id)
    respond_to do |format|
      # format.js   # show_feed_list.js.haml
    end

  end


  def index
    @userfeeds = Userfeed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @userfeeds }
    end
  end

  # GET /userfeeds/1
  # GET /userfeeds/1.json
  def show
    @userfeed = Userfeed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @userfeed }
    end
  end

  # GET /userfeeds/new
  # GET /userfeeds/new.json
  def new
    @userfeed = Userfeed.new

    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @userfeed }
    # end
  end

  # GET /userfeeds/1/edit
  def edit
    @userfeed = Userfeed.find(params[:id])
  end

  # POST /userfeeds
  # POST /userfeeds.json
  def create
    @userfeed = Userfeed.new(params[:userfeed])

    respond_to do |format|
      if @userfeed.save
        format.html { redirect_to @userfeed, notice: 'Userfeed was successfully created.' }
        format.json { render json: @userfeed, status: :created, location: @userfeed }
      else
        format.html { render action: "new" }
        format.json { render json: @userfeed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /userfeeds/1
  # PUT /userfeeds/1.json
  def update
    @userfeed = Userfeed.find(params[:id])

    respond_to do |format|
      if @userfeed.update_attributes(params[:userfeed])
        format.html { redirect_to @userfeed, notice: 'Userfeed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @userfeed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /userfeeds/1
  # DELETE /userfeeds/1.json
  def destroy
    @userfeed = Userfeed.find(params[:id])
    @userfeed.destroy

    respond_to do |format|
      format.html { redirect_to userfeeds_url }
      format.json { head :no_content }
    end
  end
end
