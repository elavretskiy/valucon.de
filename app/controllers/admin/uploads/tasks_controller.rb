class Admin::Uploads::TasksController < Admin::BaseController
  include Upload

  defaults resource_class: Task, collection_name: 'collection', instance_name: 'resource'

  private

  def set_model
    @model = Task
  end
end
