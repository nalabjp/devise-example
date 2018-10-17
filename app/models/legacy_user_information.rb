class LegacyUserInformation < ApplicationRecord
  self.table_name = name.tableize.singularize

  belongs_to :legacy_user

  validates :email, presence: true
end
