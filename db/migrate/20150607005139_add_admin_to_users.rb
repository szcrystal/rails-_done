class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolian, default: false
  end
end
