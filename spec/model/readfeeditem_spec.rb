require 'spec_helper'

describe Readfeeditem do 
  describe 'marking post as viewed' do 

    before :each do
      @userfeed = double
      @userfeed.stub(:id).and_return("5555")
      Userfeed.stub(:find_by_user_id_and_feed_id).and_return(@userfeed)
    end

    it 'should query the userfeed item' do 
      Userfeed.should_receive(:find_by_user_id_and_feed_id).with("user_id","feed_id")
      Readfeeditem.mark_as_viewed("user_id","feed_id","post_id")
    end

    it 'should create a new Readfeeditem' do 
      Readfeeditem.should_receive(:create).with(:user_id => "user_id", :feed_id => "feed_id", :feeditem_id => "post_id", :userfeed_id => "5555")
      Readfeeditem.mark_as_viewed("user_id","feed_id","post_id")
    end

    it 'should return an error if creating a new Readfeeditem failed' do 
      Readfeeditem.stub(:create).and_return(nil)
      Readfeeditem.mark_as_viewed("user_id","feed_id","post_id") == "Error occured while marking post as viewed"
    end

    it 'should return nil if creating a new Readfeeditem was sucessfull' do 
      Readfeeditem.stub(:create).and_return("this is not nil")
      Readfeeditem.mark_as_viewed("user_id","feed_id","post_id") == nil
    end

  end

  describe 'marking post as unread' do 

    it 'should delete all entries of a post in Readfeeditems table' do
      Readfeeditem.should_receive(:delete_all).with(:user_id => "user_id", :feed_id => "feed_id", :feeditem_id => "post_id")
      Readfeeditem.mark_as_unread("user_id","feed_id","post_id")
    end

    it 'should return an error if deleting entry failed' do 
      Readfeeditem.stub(:delete_all).and_return(nil)
      Readfeeditem.mark_as_unread("user_id","feed_id","post_id") == "Error occured while marking post and unread."
    end

    it 'should return nil if deleting entry was successfull' do 
      Readfeeditem.stub(:delete_all).and_return("this is not nil")
      Readfeeditem.mark_as_unread("user_id","feed_id","post_id") == nil
    end

  end

end