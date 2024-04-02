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
    true
  end

  def exposant?
    true
  end

end
