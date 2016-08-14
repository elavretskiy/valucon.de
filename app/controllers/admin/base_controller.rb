class Admin::BaseController < ApplicationController
  inherit_resources

  before_action :authorize?

  def authorize?
    return if current_user.present?
    msg = 'Ошибка авторизации'
    respond_to do |format|
      format.html { redirect_to new_admin_session_path, alert: msg }
      format.json {
        render json: { msg: msg, redirect_to: 'new_admin_session_path' },
               status: 401
      }
    end
  end
end
