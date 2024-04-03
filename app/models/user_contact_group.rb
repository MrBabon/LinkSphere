class UserContactGroup < ApplicationRecord
  belongs_to :user
  belongs_to :contact_group
end
