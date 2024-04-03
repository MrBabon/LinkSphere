class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def visitor?
    user.admin? || participant_visible?
  end

  def exposant?
    true
  end

  private

  def participant_visible?
    # Vérifie si current_user est marqué comme visible dans les participations de l'événement
    record.participations.where(user: user).first&.visible_in_participants || false
  end

end
