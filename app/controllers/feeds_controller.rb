class FeedsController < ApplicationController
  before_filter :login_required

  # def prepare_userfeed_form
  #   @feed = Feed.new
  # end
  # GET /feeds
  # GET /feeds.json
  def index

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @feeds }
    # end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])

    feed_url = @feed[:feed_url]
    userid = current_user.uid

    f = Feed.addFeed(feed_url, userid)
    if f == false
      flash[:alert] = "Error occured while adding the feed. Please try again later."
      redirect_to userfeeds_path
    else
      flash[:notice] = "Feed Added Successfully"
      redirect_to userfeeds_path
    end


    # if @feed.save
    #   flash[:notics] = "Feed added successfully"
    #   redirect_to userfeeds_path
    # else
    #   flash[:alert] = "error adding feed"
    #   redirect_to userfeeds_path
    # end
  end

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end
end
