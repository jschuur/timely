class User < ActiveRecord::Base
  has_many :tweets

  attr_accessible :email_address, :time_zone, :bitly_username, :bitly_api_key
end
