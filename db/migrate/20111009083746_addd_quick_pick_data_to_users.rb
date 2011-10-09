class AdddQuickPickDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quick_pick_start, :integer, :default => 7
    add_column :users, :quick_pick_interval, :integer, :default => 5
  end
end
