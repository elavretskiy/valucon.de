class Admin::SessionsController < Admin::BaseController
  skip_before_action :authorize?, only: [:new, :create]
  before_action :set_user, only: [:create]
  before_action :authorized?

  add_breadcrumb 'Авторизация', :new_admin_session_path

  def new
    @user = User.new
    respond_with @user
  end

  def create
    respond_to do |format|
      if @user.try(:authenticate, user_params[:password])
        session[:user_id] = @user.id
        success_create_respond_to(format)
      else
        failure_create_respond_to(format)
      end
    end
  end

  private

  def set_user
    @user = User.find_by(email: user_params[:email])
  end

  def user_params
    params.require(:user).permit(policy(User).permitted_attributes)
  end

  def success_create_respond_to(format)
    msg = 'Успешная авторизация'
    format.html { redirect_to admin_tasks_path, notice: msg }
    format.json { render json: { msg: msg, redirect_to: 'admin_tasks_path' } }
  end

  def failure_create_respond_to(format)
    @user ||= User.new(user_params)
    @user.valid?
    msg = 'Проверьте правильность введенных данных'
    format.html { render :new, alert: msg }
    format.json { render json: { errors: @user.errors, msg: msg }, status: 401 }
  end

  def authorized?
    return if current_user.blank?
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { redirect_to: 'root_path' } }
    end
  end
end
