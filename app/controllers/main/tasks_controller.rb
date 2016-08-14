class Main::TasksController < Main::BaseController
  include Resource

  defaults resource_class: Task, collection_name: 'collection', instance_name: 'resource'

  add_breadcrumb 'Задачи системы', :root_path

  has_scope :search

  protected

  def collection
    get_collection_ivar || set_collection_ivar(apply_scopes(Task).index.page(params[:page]))
  end

  private

  def set_model
    @model = Task
  end

  def index_render_json
    @collection.includes(:user).as_json(Task.as_json_include)
  end
end
