require 'spec_helper'

describe Readfeeditem do
  describe 'mark_as_viewed method' do
    before :each do
      @ufeed = double
      @ufeed.stub(:id).and_return('123')
    end
    it 'should get the respective userfeed' do
      Userfeed.should_receive(:find_by_user_id_and_feed_id).with('userid123','feedid123')
      Userfeed.stub(:find_by_user_id_and_feed_id).and_return(@ufeed)
      Readfeeditem.mark_as_viewed('userid123', 'feedid123','postid123')
    end
    describe 'after getting userfeed'  do
      before :each do
        Userfeed.stub(:find_by_user_id_and_feed_id).and_return(@ufeed)
      end

      it 'should create readfeeditem' do
        Readfeeditem.should_receive(:create).with(:user_id => 'userid123',:feed_id => 'feedid123',
                                                  :feeditem_id => 'postid123',:userfeed_id => '123')
        Readfeeditem.mark_as_viewed('userid123', 'feedid123','postid123')
      end
      it 'should return error if creating readfeeditem was unsuccessful' do
        Readfeeditem.stub(:create).and_return(nil)
        Readfeeditem.mark_as_viewed('userid123', 'feedid123','postid123') == 'Error occured while marking post as viewed'
      end

      it 'should return nil if creating readfeeditem was successful' do
        Readfeeditem.stub(:create).and_return('notnil')
        Readfeeditem.mark_as_viewed('userid123', 'feedid123','postid123') == nil
      end
    end
  end

  describe 'mark_as_unread method' do
    it 'should delete readfeeditem' do
      Readfeeditem.should_receive(:delete_all).with(:user_id => 'userid123', :feed_id => 'feedid123', :feeditem_id => 'postid123')
      Readfeeditem.mark_as_unread('userid123', 'feedid123','postid123')
    end
    it 'should return an error if deleting readfeeditem was unseccessful' do
      Readfeeditem.stub(:delete_all).and_return(nil)
      Readfeeditem.mark_as_unread('userid123', 'feedid123','postid123') == 'Error occured while marking post as
unread.'
    end
    it 'should return nil if deleting readfeeditem was successful' do
      Readfeeditem.stub(:delete_all).and_return('notnil')
      Readfeeditem.mark_as_unread('userid123', 'feedid123','postid123')  == nil
    end
  end
end
