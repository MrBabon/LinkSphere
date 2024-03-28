class ContactEntreprise < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :entreprise
end
