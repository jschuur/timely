class AddEmailBitlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_address, :string
    add_column :users, :bitly_username, :string
    add_column :users, :bitly_api_key, :string
  end
end
