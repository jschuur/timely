class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :user
      t.string :long_url
      t.string :short_url
      t.string :message
      t.integer :user_clicks, :default => 0
      t.integer :global_clicks, :default => 0
      t.string :status, :default => 'pending'
      t.datetime :scheduled_date

      t.timestamps
    end
  end
end
