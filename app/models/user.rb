class User < ActiveRecord::Base
  # set_primary_key :uid
  has_many :userfeeds, :dependent => :destroy  
  has_many :readfeeditems, :dependent => :destroy

  attr_accessible :name, :provider, :uid, :profile_pic,:refresh_token, :access_token, :expires
  validates_uniqueness_of :uid, :scope => :provider
end
