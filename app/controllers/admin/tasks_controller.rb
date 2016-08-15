class Admin::TasksController < Admin::BaseController
  include Upload
  include Resource

  defaults resource_class: Task, collection_name: 'collection', instance_name: 'resource'

  add_breadcrumb 'Задачи пользователя', :admin_tasks_path

  has_scope :search
  has_scope :by_state, as: :filter, using: [:by_state], type: :hash, default: 'all'

  def new
    @resource = current_user.tasks.new
    new_breadcrumb
    authorize @resource
    new!
  end

  def update
    authorize @resource
    remove_upload_at_index(params[:remove_upload])
    respond_to do |format|
      if @resource.update(resource_params)
        format.json { success_update_render_json }
      else
        format.json { failure_render_json }
      end
    end
  end

  protected

  def collection
    get_collection_ivar || set_collection_ivar(apply_scopes(policy_scope(end_of_association_chain)).index.page(params[:page]))
  end

  private

  def set_model
    @model = Task
  end

  def index_render_json
    current_user.is_user? ? @collection : @collection.includes(:user).as_json(Task.as_json_include)
  end

  def show_render_json
    current_user.is_user? ? @resource : @resource.as_json(Task.as_json_include)
  end

  def failure_render_json
    state_event = resource_params[:state_event].present?
    msg = state_event ? @resource.errors.full_messages.uniq.join(', ') : nil
    render json: { errors: @resource.errors, msg: msg }, status: 422
  end

  def success_updated_messages
    state_event = resource_params[:state_event].present?
    state_event ? 'Состояние успешно изменено' : t('activerecord.successful.messages.updated')
  end

  def success_update_redirect
    remove_upload = params[:remove_upload].present?
    remove_upload ? "admin_task_path#{@resource}" : 'admin_tasks_path'
  end

  def success_create_redirect
    'admin_tasks_path'
  end

  def success_destroy_redirect
    'admin_tasks_path'
  end

  def show_breadcrumb
    add_breadcrumb Breadcrumbs.text(params), [:admin, @resource]
  end

  def new_breadcrumb
    add_breadcrumb Breadcrumbs.text(params), [:new, :admin, model_name.to_sym]
  end

  def edit_breadcrumb
    add_breadcrumb Breadcrumbs.text(params), [:edit, :admin, @resource]
  end
end
