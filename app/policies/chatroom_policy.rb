class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where("user1_id = :user_id OR user2_id = :user_id", user_id: user.id)
    end
  end

  def create?
    true
  end

  def show?
    true
  end

end
