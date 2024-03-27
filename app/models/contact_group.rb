class ContactGroup < ApplicationRecord
  belongs_to :repertoire
  has_many :user_contact_groups, dependent: :destroy
  has_many :users, through: :user_contact_groups
end
