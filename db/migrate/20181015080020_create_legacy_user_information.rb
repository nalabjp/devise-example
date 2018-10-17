# frozen_string_literal: true

class CreateLegacyUserInformation < ActiveRecord::Migration[5.2]
  def change
    create_table :legacy_user_information do |t|
      t.integer :legacy_user_id,    null: false
      t.string :email,              null: false, default: ""

      t.timestamps null: false
    end
  end
end
