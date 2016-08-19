class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_user

  respond_to :html, :json

  add_breadcrumb 'Главная', :root_path

  layout proc { request.xhr? ? 'content_wrapper' : 'admin_lte_2' }

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # :nocov:
  def user_not_authorized
    msg = 'У Вас недостаточно прав для выполнения данных действий'
    if request.xhr?
      render json: { msg: msg }, status: 403
    else
      flash[:alert] = msg
      redirect_to request.referrer || root_path
    end
  end
  # :nocov:
end
