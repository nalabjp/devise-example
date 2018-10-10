class ChangeUserToLegacyUser < ActiveRecord::Migration[5.2]
  def change
    rename_table :users, :legacy_users
  end
end
