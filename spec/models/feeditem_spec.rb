require 'spec_helper'

describe Feeditem do
  describe 'get_all_post method' do
    it 'should call get read and unread post list methods'  do
      Feeditem.should_receive(:get_read_post_list).with('uid123','fid123')
      Feeditem.should_receive(:get_unread_post_list).with('uid123','fid123')
      Feeditem.get_all_posts('uid123','fid123')
    end
  end
end
