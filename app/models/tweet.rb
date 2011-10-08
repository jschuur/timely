class Tweet < ActiveRecord::Base
  belongs_to :user

  scope :pending, where(:status => 'pending')
end
