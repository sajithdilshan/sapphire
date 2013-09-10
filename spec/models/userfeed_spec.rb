require 'spec_helper'

describe Userfeed do
  describe 'get_userfeed_with_feed method' do
    it 'should return userfeed and feed' do
      Userfeed.should_receive(:where).with('user_id' => 'userid1234')
      Feed.should_receive(:unordered_feed_list).with('userid1234')
      Userfeed.get_userfeed_with_feed('userid1234')
    end

  end

end
