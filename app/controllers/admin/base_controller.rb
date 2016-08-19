class Admin::BaseController < ApplicationController
  inherit_resources

  before_action :authorize?

  private

  def authorize?
    return if current_user.present?
    msg = 'Ошибка авторизации'
    respond_to do |format|
      format.html { redirect_to new_admin_session_path }
      format.json {
        render json: { msg: msg, redirect_to: 'new_admin_session_path', reload: true },
               status: 401
      }
    end
  end
end
