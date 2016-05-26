class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin_user, :boolean
  end
end
