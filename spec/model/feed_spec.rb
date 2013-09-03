require 'spec_helper'

describe Feed do 
  describe 'adding feed by feed url' do 
    it 'should call Feedzirra with the feed url' do 
      Feedzirra::Feed.should_receive(:fetch_and_parse).with('feed_url')
      Feed.addFeed("feed_url","userid")
    end

    it 'should return alert if the fectching feed was a failiure' do
      Feedzirra::Feed.stub(:fetch_and_parse).with("f_url").and_return(nil)
      Feed.addFeed("f_url","userid").should == {alert: "Error occured while fetching feed. Please try again later."}
    end


    describe 'after sucessfully fetching the feed' do
      before :each do
        fetched_feed = double
        fetched_feed.stub(:feed_url).and_return("http://fakefeedurl.com")
        fetched_feed.stub(:title).and_return("fake title")
      
        post = double
        post.stub(:content).and_return("fakecontent")
        post.stub(:summary).and_return("fakesummary")
        post.stub(:title).and_return("faketitle")
        post.stub(:published).and_return("fakepubdate")
        post.stub(:url).and_return("fakeurl")
        entries = [post]
        fetched_feed.stub(:entries).and_return(entries)

        Feedzirra::Feed.stub(:fetch_and_parse).with("f_url").and_return(fetched_feed)
     
        @feed = double
        @feed.stub(:id).and_return('5')
        @user = double
        @user.stub(:uid).and_return('11')
        User.stub(:find_by_uid).and_return(@user)

      end

      it 'should not return an error if fetching feed was successfull' do
        Feed.addFeed("f_url","userid")
      end

      it 'should check if the feed exisits' do 
        Feed.should_receive(:find_by_feed_url).with("http://fakefeedurl.com")
        Feed.addFeed("f_url","userid")
      end

      it 'should check if userfeed exist when the feed is already there' do
        Feed.stub(:find_by_feed_url).and_return(@feed)
        Userfeed.should_receive(:find_by_user_id_and_feed_id).with("userid",'5')
        Feed.addFeed("f_url","userid")
      end

      it 'should not check if userfeed exist when feed is not there already' do
        Userfeed.should_not_receive(:find_by_user_id_and_feed_id).with("userid",'5')
        Feed.addFeed("f_url","userid")
      end

      it 'should return if userfeed exits' do
        Userfeed.stub(:find_by_user_id_and_feed_id).and_return("this is not nil")
        Feed.addFeed("f_url","userid") == {notice: "You have already added that feed"}
      end

      it 'should find userid of current user if userfeed does not exist' do
        Userfeed.stub(:find_by_user_id_and_feed_id).and_return(nil)
        User.should_receive(:find_by_uid).with("userid")
        Feed.addFeed("f_url","userid")
      end

      it 'should create userfeed for current user if userfeed does not exist and return sucess' do
        Userfeed.stub(:find_by_user_id_and_feed_id).and_return(nil)
        Feed.stub(:find_by_feed_url).and_return(@feed)
        Userfeed.should_receive(:create).with(:user_id => '11', :category => 'default', :lastread => nil, :feed_id => '5')
        Feed.addFeed("f_url","userid") == {notice: "Feed added Successfully"}
      end

      describe 'feed is not already there and user has not added it before' do
        it 'should create a new feed' do
          Feed.should_receive(:create).with(:feed_name => "fake title", :feed_url =>"http://fakefeedurl.com")
          Feed.addFeed("f_url","userid")
        end

        it 'should return an error message if creating feed waas unsuccessful' do
          Feed.stub(:create).and_return(nil)
          Feed.addFeed("f_url","userid") == {alert: "Error occured while creating feed. Please try again later."}
        end

        it 'should create feed item if creating feed was successful' do
          Feed.stub(:create).and_return(@feed)
          Feeditem.should_receive(:create).with(:feed_id => '5', :post_title => "faketitle", :post_pub_date => "fakepubdate", :post_body => "fakecontent", :post_url => "fakeurl")
          Feed.addFeed("f_url","userid")
        end

        it 'should find userid of current user' do
          User.should_receive(:find_by_uid).with("userid")
          Feed.addFeed("f_url","userid")
        end

        it 'shoul create userfeed for current user and return success' do
          Feed.stub(:find_by_feed_url).and_return(@feed)
          Userfeed.should_receive(:create).with(:user_id => '11', :category => "default",:lastread => nil, :feed_id => '5')
          Feed.addFeed("f_url","userid") == {notice: "Feed added Successfully"}
        end

      end #end of "feed is not already there and user has not added it before" describe block
    end #end of "after sucessfully fetching the feed" describe block
  end #end of "adding feed by feed url" describe block
end