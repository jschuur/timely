class AddErrorToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :error, :string
  end
end
