class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @user.present? && (@user.is_admin? || @user.tasks.include?(@record))
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    @user.present?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def permitted_attributes
    base_params = [:id, :name, :description, :state, :remove_upload, :upload,
                   :state_event]
    admin_params = [:user_id]
    @user.try(:is_admin?) ? admin_params + base_params : base_params
  end

  class Scope < Scope
    def resolve
      case true
      when @user.blank?
        Task.none
      when @user.is_admin?
        Task.all
      when @user.is_user?
        @user.tasks
      else
        Task.none
      end
    end
  end
end
