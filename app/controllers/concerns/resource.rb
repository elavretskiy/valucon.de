module Resource
  extend ActiveSupport::Concern

  included do
    respond_to :html, :json

    before_action :set_model
    before_action :set_resource, only: [:show, :edit, :update, :destroy]

    def index
      authorize @model
      index! { |format| format.json { render json: index_respond_json } }
    end

    def show
      authorize @resource
      show_breadcrumb
      show! { |format| format.json { render json: show_render_json } }
    end

    def new
      @resource = @model.new
      new_breadcrumb
      authorize @resource
      new!
    end

    def edit
      authorize @resource
      edit_breadcrumb
      edit!
    end

    def create
      @resource = @model.new
      authorize @resource
      @resource.assign_attributes resource_params
      create! { |success, failure| create_respond_json(success, failure) }
    end

    def update
      authorize @resource
      respond_to do |format|
        if @resource.update(resource_params)
          format.json { success_update_render_json }
        else
          format.json { failure_render_json }
        end
      end
    end

    def destroy
      authorize @resource
      destroy! { |format| destroy_respond_json(format) }
    end

    private

    def resource_params
      params.require(model_name.to_sym).permit(policy(@resource).permitted_attributes)
    end

    def set_resource
      @resource = policy_scope(@model).find(params[:id])
    end

    def create_respond_json(success, failure)
      success.json { success_create_render_json }
      failure.json { failure_render_json }
    end

    def failure_render_json
      # msg = @resource.errors.full_messages.uniq.join(', ')
      render json: { errors: @resource.errors }, status: 422
    end

    def index_respond_json
      {
        total_count: @collection.total_count,
        collection: index_render_json,
        page: params[:page] || 1,
        search: params[:search],
        filter: params[:filter],
        page_size: @collection.limit_value
      }
    end

    def index_render_json
      @collection
    end

    def show_render_json
      @resource
    end

    def success_create_render_json
      success_render_json(success_created_message, success_create_redirect)
    end

    def success_update_render_json
      success_render_json(success_updated_messages, success_update_redirect)
    end

    def success_render_json(msg, redirect_to)
      render json: { "#{model_name}": show_render_json, msg: msg, redirect_to: redirect_to }
    end

    def destroy_respond_json(format)
      format.json { success_render_json(success_destroyed_message,
                                        success_destroy_redirect) }
    end

    def success_updated_messages
      t('activerecord.successful.messages.updated')
    end

    def success_created_message
      t('activerecord.successful.messages.created')
    end

    def success_destroyed_message
      t('activerecord.successful.messages.destroyed')
    end

    def success_update_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def success_create_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def success_destroy_redirect
      "#{model_name.pluralize(3)}_path"
    end

    def show_breadcrumb
      add_breadcrumb Breadcrumbs.text(params), [@resource]
    end

    def new_breadcrumb
      add_breadcrumb Breadcrumbs.text(params), [:new, model_name.to_sym]
    end

    def edit_breadcrumb
      add_breadcrumb Breadcrumbs.text(params), [:edit, @resource]
    end

    def model_name
      @model.model_name.to_s.underscore
    end
  end
end
