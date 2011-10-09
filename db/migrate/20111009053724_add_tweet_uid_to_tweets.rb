class AddTweetUidToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_uid, :string
  end
end
