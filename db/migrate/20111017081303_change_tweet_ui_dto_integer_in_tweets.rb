class ChangeTweetUiDtoIntegerInTweets < ActiveRecord::Migration
  def change
    change_column :tweets, :tweet_uid, :integer, :default => nil, :limit => 8
  end
end