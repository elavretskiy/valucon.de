class UserPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    index?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def permitted_attributes
    [:email, :password]
  end

  class Scope < Scope
    def resolve
      User.none
    end
  end
end
