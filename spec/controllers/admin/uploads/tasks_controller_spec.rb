require 'rails_helper'

RSpec.describe Admin::Uploads::TasksController, type: :controller do
  describe 'not authorize' do
    it 'create' do
      post :create, format: :json
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end
  end

  describe 'authorize' do
    before(:each) do
      @task = FactoryGirl.create(:task)
      @user = @task.user
      @request.session[:user_id] = @user.id
      file = fixture_file_upload('files/test.jpg', 'image/jpg')
      post :create, { task_id: @task.id, file: file, format: :json }
    end

    it 'create' do
      @task.reload
      expect(@task.uploads[0].file.filename).to eq 'test.jpg'
      expect(@task.uploads.count).to eq 1
    end
  end
end
