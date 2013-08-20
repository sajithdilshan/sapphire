class Userfeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  has_many :feeds, :dependent => :destroy
  attr_accessible :category, :lastread, :user_id, :id, :feed_id


end
