class AddSentDateToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :sent_date, :datetime
  end
end
