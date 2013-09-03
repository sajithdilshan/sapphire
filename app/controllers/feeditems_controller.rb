class FeeditemsController < ApplicationController
  
  # # GET /feeditems
  # # GET /feeditems.json
  # def index
  #   @feeditems = Feeditem.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @feeditems }
  #   end
  # end

  # # GET /feeditems/1
  # # GET /feeditems/1.json
  # def show
  #   @feeditem = Feeditem.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @feeditem }
  #   end
  # end

  # # GET /feeditems/new
  # # GET /feeditems/new.json
  # def new
  #   @feeditem = Feeditem.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @feeditem }
  #   end
  # end

  # # GET /feeditems/1/edit
  # def edit
  #   @feeditem = Feeditem.find(params[:id])
  # end

  # # POST /feeditems
  # # POST /feeditems.json
  # def create
  #   @feeditem = Feeditem.new(params[:feeditem])

  #   respond_to do |format|
  #     if @feeditem.save
  #       format.html { redirect_to @feeditem, notice: 'Feeditem was successfully created.' }
  #       format.json { render json: @feeditem, status: :created, location: @feeditem }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @feeditem.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PUT /feeditems/1
  # # PUT /feeditems/1.json
  # def update
  #   @feeditem = Feeditem.find(params[:id])

  #   respond_to do |format|
  #     if @feeditem.update_attributes(params[:feeditem])
  #       format.html { redirect_to @feeditem, notice: 'Feeditem was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @feeditem.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /feeditems/1
  # # DELETE /feeditems/1.json
  # def destroy
  #   @feeditem = Feeditem.find(params[:id])
  #   @feeditem.destroy

  #   respond_to do |format|
  #     format.html { redirect_to feeditems_url }
  #     format.json { head :no_content }
  #   end
  # end
end
