class UserContactGroup < ApplicationRecord
  belongs_to :user
  belongs_to :contactGroup
end
