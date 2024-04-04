class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Soyez explicite sur les enregistrements auxquels vous autorisez l’accès!
    def resolve
      scope.all
    end
  end

  def profil?
    true
  end

  def settings?
    true
  end

  def my_events?
    true
  end

  def show?
    true
  end

  def add_to_directory?
    true
  end

  def repertoire_user_profil?
    true
  end
  
end
