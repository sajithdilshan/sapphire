require 'spec_helper'

describe Feed do
  before :each do
    @fetched_feed = double
    @fetched_feed.stub(:id).and_return('5')
    @fetched_feed.stub(:feed_url).and_return('fakefeedurl')
    @fetched_feed.stub(:title).and_return('fake title')

    @post = double
    @post.stub(:content).and_return('fakecontent')
    @post.stub(:summary).and_return('fakesummary')
    @post.stub(:title).and_return('faketitle')
    @post.stub(:published).and_return('fakepubdate')

    @post.stub(:url).and_return('fakeurl')
    entries = [@post]
    @fetched_feed.stub(:entries).and_return(entries)

    @feed = double
    @feed.stub(:id).and_return('5')

    @user = double
    @user.stub(:uid).and_return('11')

  end


  describe 'update_user_feeds method' do
    before :each do
      @fg_feed =  FactoryGirl.build(:feed)
      @fg_feeditem = FactoryGirl.build(:feeditem)
      Feeditem.stub(:where).and_return([@fg_feeditem,@fg_feeditem])
    end

    it 'should return if the user does not has any feed' do
      Feed.stub_chain(:joins,:where).and_return(nil)
    end

    describe 'provided that the user has feeds' do

      describe 'creates feed id and url list' do
        before :each do
          @post.stub_chain(:published,:to_time).and_return(2)
        end

        it 'for one Feed' do
          Feed.stub_chain(:joins,:where).and_return(@fg_feed)
        end

        it 'for an Array of Feed' do
          Feed.stub_chain(:joins,:where).and_return([@fg_feed,@fg_feed])
        end

        after :each do
          Feedzirra::Feed.stub(:fetch_and_parse).and_return(@fetched_feed)
        end
      end

      describe 'after creating feed id and url list' do
        before :each do
          Feed.stub_chain(:joins,:where).and_return(@fg_feed)
        end
        it 'should fetch feeds from feedzirra' do
          Feedzirra::Feed.should_receive(:fetch_and_parse).with('hello world url')
        end

        it 'should return if fetched feed is nil' do
          Feedzirra::Feed.stub(:fetch_and_parse).and_return(nil)
        end

        describe 'after successfully fetching the feed' do
          before :each do
            Feedzirra::Feed.stub(:fetch_and_parse).and_return(@fetched_feed)
          end

          it 'should create Feeditem if posts are newer than last post in Feeditems' do
            @post.stub_chain(:published,:to_time).and_return(10)
            Feeditem.should_receive(:create).with(:feed_id => 55, :post_title => 'faketitle', :post_pub_date => 'fakepubdate', :post_body => 'fakecontent', :post_url => 'fakeurl')
          end

          it 'should not create Feeditem if there are no new posts' do
            @post.stub_chain(:published,:to_time).and_return(2)
            Feeditem.should_not_receive(:create).with(:feed_id => 55, :post_title => 'faketitle', :post_pub_date => 'fakepubdate', :post_body => 'fakecontent', :post_url => 'fakeurl')
          end
        end
      end
    end

    after :each do
      Feed.update_user_feeds('userid')
    end
  end


  describe 'add_feed Method ' do

    describe 'Before fetching feed ' do
      it 'should check if the feed already exists' do
        Feed.should_receive(:find_by_feed_url).with('feed_url')
        Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
      end
      it 'should call Feedzirra with the feed url if feed does not exist' do
        Feed.stub(:find_by_feed_url).and_return(nil)
        Feedzirra::Feed.should_receive(:fetch_and_parse).with('feed_url')
      end
      it 'should not call feedzirra if feed exist' do
        Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
        Feedzirra::Feed.should_not_receive(:fetch_and_parse).with('feed_url')
      end
      after :each do
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid')
      end
    end

    it 'should return alert if the fectching feed was a failiure' do
      Feedzirra::Feed.stub(:fetch_and_parse).with('feed_url').and_return(nil)
      Feed.add_feed('feed_url', 'userid').should == {alert: 'Error occured while fetching feed. Please try again later.'}
    end

    describe 'after sucessfully fetching the feed' do
      it 'should check if userfeed exist when the feed is already there' do
        Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
        Userfeed.should_receive(:find_by_user_id_and_feed_id).with('userid','5')
      end
      it 'should not check if userfeed exist when feed is not there already' do
        Feed.stub(:find_by_feed_urll).and_return(nil)
        Userfeed.should_not_receive(:find_by_user_id_and_feed_id).with('userid','5')
        Feedzirra::Feed.stub(:fetch_and_parse).with('feed_url').and_return(@fetched_feed)
      end
      after :each do
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid')
      end
    end

    it 'should return if user tries to add duplicate feed' do
      Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
      Userfeed.stub(:find_by_user_id_and_feed_id).and_return('this is not nil')
      Feed.add_feed('f_url', 'userid') == {notice: 'You have already added that feed'}
    end

    describe 'feed exists but userfeed does not exist' do
      before :each do
        Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
        Userfeed.stub(:find_by_user_id_and_feed_id).and_return(nil)
      end
      it 'should find userid of current user' do
        User.should_receive(:find_by_uid).with('userid')
      end
      after :each do
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid')
      end
    end

    it 'should create userfeed for current user and return sucess if feed already exists' do
      Feed.stub(:find_by_feed_url).and_return(@fetched_feed)
      Userfeed.stub(:find_by_user_id_and_feed_id).and_return(nil)
      Userfeed.should_receive(:create).with(:user_id => '11', :category => 'default', :lastread => nil, :feed_id => '5')
      User.stub(:find_by_uid).and_return(@user)
      Feed.add_feed('feed_url', 'userid') == {notice: 'Feed added Successfully'}
    end

    describe 'feed is not already there and obviously no user has added it before' do
      before :each do
        Feed.stub(:find_by_feed_url).and_return(nil)
        Feedzirra::Feed.stub(:fetch_and_parse).with('feed_url').and_return(@fetched_feed)
      end
      it 'should create a new feed' do
        Feed.should_receive(:create).with(:feed_name => 'fake title', :feed_url => 'fakefeedurl')
      end
      it 'should create feed items if creating feed was successful' do
        Feed.stub(:create).and_return(@feed)
        Feeditem.should_receive(:create).with(:feed_id => '5', :post_title => 'faketitle', :post_pub_date => 'fakepubdate', :post_body => 'fakecontent', :post_url => 'fakeurl')
      end
      after :each do
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid')
      end
    end
  
    it 'should return an error message if creating feed was unsuccessful' do
      Feed.stub(:find_by_feed_url).and_return(nil)
      Feedzirra::Feed.stub(:fetch_and_parse).with('feed_url').and_return(@fetched_feed)
      Feed.stub(:create).and_return(nil)
      Feed.add_feed('feed_url', 'userid') == {alert: 'Error occured while creating feed. Please try again later.'}
    end

    describe 'after creating new feed and feed entries successfully' do
      before :each do
        Feed.stub(:find_by_feed_url).and_return(nil)
        Feedzirra::Feed.stub(:fetch_and_parse).with('feed_url').and_return(@fetched_feed)
        Feed.stub(:create).and_return(@feed)
      end
      it 'should find userid of current user' do
        User.should_receive(:find_by_uid).with('userid')
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid')
      end
      it 'shoul create userfeed for current user and return success' do
        Userfeed.should_receive(:create).with(:user_id => '11', :category => 'default',:lastread => nil, :feed_id => '5')
        User.stub(:find_by_uid).and_return(@user)
        Feed.add_feed('feed_url', 'userid') == {notice: 'Feed added Successfully'}
      end
    end

  end


end