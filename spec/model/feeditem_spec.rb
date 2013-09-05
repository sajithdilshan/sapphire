require 'spec_helper'

describe Feeditem do 
  describe 'get_feed_list Method ' do 
    before :each do
      @read_f1 = double
      @read_f2 = double
      @unread_f1 = double
      @unread_f2 = double
      @read_f1.stub(:id).and_return("25")
      @read_f2.stub(:id).and_return("75")
      @unread_f1.stub(:id).and_return("100")
      @unread_f2.stub(:id).and_return("101")
      @read_f1.stub(:post_pub_date).and_return("1")
      @read_f2.stub(:post_pub_date).and_return("52")
      @unread_f1.stub(:post_pub_date).and_return("99")
      @unread_f2.stub(:post_pub_date).and_return("7")
      @unread_feeds = [@unread_f1,@unread_f2]
      @read_feeds =[@read_f1,@read_f2]
      @all_feeds =[@unread_f2, @unread_f1, @read_f1,@read_f2]

    end

    it 'should return all posts and nil if no read items exits' do
      Feeditem.stub(:find_all_by_feed_id).and_return(@all_feeds)
      Feeditem.stub_chain(:joins,:where).and_return(nil)
      Feeditem.get_feed_list("user_id","feed_id") == [@all_feeds , nil]
    end
    describe "if read items exits" do
      it 'should return unread and read feeditems ordered in published date' do
        Feeditem.stub(:find_all_by_feed_id).and_return(@all_feeds)
        Feeditem.stub_chain(:joins,:where).and_return(@read_feeds)
        Feeditem.get_feed_list("user_id","feed_id") ==[@unread_feeds, @read_feeds]
      end
    end

  end
end