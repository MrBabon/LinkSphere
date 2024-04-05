class Chatroom < ApplicationRecord
    belongs_to :user1, class_name: 'User', foreign_key: 'user1_id'
    belongs_to :user2, class_name: 'User', foreign_key: 'user2_id'
    has_many :messages, dependent: :destroy
  

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

    def other_user(current_user)
      user1 == current_user ? user2 : user1
    end

    def participant?(user)
      user1_id == user.id || user2_id == user.id
    end
end
