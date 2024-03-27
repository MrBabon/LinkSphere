class Repertoire < ApplicationRecord
  after_create :create_default_group
  belongs_to :user
  has_many :contact_groups, dependent: :destroy

  # PG SEARCH
  include PgSearch::Model
  pg_search_scope :search_by_first_name,
    against: :first_name,
    using: {
      tsearch: { prefix: true } 
    } 
  pg_search_scope :search_by_last_name,
    against: :last_name,
    using: {
      tsearch: { prefix: true } 
    }

  private

  def create_default_group
    self.contact_groups.create!(name: 'Everyone', deletable: false)
  end
end
