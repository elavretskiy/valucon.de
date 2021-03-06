module Upload
  extend ActiveSupport::Concern

  included do
    before_action :set_model
    before_action :set_resource, only: [:create]

    def create
      authorize @resource
      add_more_uploads([params[:file]])
      @resource.save
      render json: @resource
    end

    private

    def set_resource
      @resource = policy_scope(@model).find(params[:task_id])
    end

    def add_more_uploads(new_uploads)
      uploads = @resource.uploads
      uploads += new_uploads
      @resource.uploads = uploads
    end

    def remove_upload_at_index(index)
      return if index.blank?
      remain_uploads = @resource.uploads
      deleted_upload = remain_uploads.delete_at(index.to_i)
      deleted_upload.try(:remove!)
      @resource.uploads = remain_uploads
      @resource.remove_uploads = true if remain_uploads.blank?
    end
  end
end
