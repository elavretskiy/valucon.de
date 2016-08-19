require 'rails_helper'

RSpec.describe Admin::TasksController, type: :controller do
  describe 'not authorize' do
    before(:each) do
      @task = FactoryGirl.create(:task)
    end

    it 'index' do
      get :index, format: :json
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'show' do
      get :show, { id: @task.id, format: :json }
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'edit' do
      get :edit, { id: @task.id, format: :json }
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'new' do
      get :new, format: :json
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'create' do
      post :create, format: :json
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'update' do
      put :update, { id: @task.id, format: :json }
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end

    it 'destroy' do
      delete :destroy, { id: @task.id, format: :json }
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq 'new_admin_session_path'
    end
  end

  describe 'authorize user' do
    before(:each) do
      @user_task = FactoryGirl.create(:task)

      @user = FactoryGirl.create(:user, :admin)
      @admin_task = FactoryGirl.create(:task)
      @user.tasks << @admin_task

      @request.session[:user_id] = @user_task.user_id
      @resource = @user_task.as_json(Task.as_json_include)
    end

    it 'index' do
      get :index, format: :json
      json = JSON.parse(response.body)
      expect(json['total_count']).to eq 1
      expect(json['collection'][0]['name']).to eq @resource['name']
    end

    describe 'show' do
      it 'user task' do
        get :show, { id: @user_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @resource['name']
        expect(json['description']).to eq @resource['description']
        expect(json['state']).to eq @resource['state']
        expect(json['user']).to eq nil
      end

      it 'admin task' do
        expect { get :show, { id: @admin_task.id, format: :json } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    describe 'edit' do
      it 'user task' do
        get :edit, { id: @user_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @resource['name']
        expect(json['description']).to eq @resource['description']
      end

      it 'admin task' do
        expect { get :edit, { id: @admin_task.id, format: :json } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    it 'new' do
      get :new, { id: @user_task.id, format: :json }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'create' do
      post :create, { task: { name: 'test name',
                              description: 'test description',
                              user_id: @user.id }, format: :json }
      task = Task.last
      expect(task.name).to eq 'test name'
      expect(task.description).to eq 'test description'
      expect(task.user_id).to eq @user_task.user_id
      expect(task.state).to eq 'new'
    end

    describe 'update' do
      it 'user task' do
        put :update, { id: @user_task.id, task: { name: 'test name',
                                                  description: 'test description',
                                                  user_id: @user.id,
                                                  state: 'started' }, format: :json }
        @user_task.reload
        expect(@user_task.name).to eq 'test name'
        expect(@user_task.description).to eq 'test description'
        expect(@user_task.user_id).to eq @user_task.user_id
        expect(@user_task.state).to eq 'new'
      end

      it 'admin task' do
        expect { put :update, { id: @admin_task.id, task: { name: 'test name',
                                                           description: 'test description',
                                                           user_id: @user.id,
                                                           state: 'started' }, format: :json } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    describe 'destroy' do
      it 'user task' do
        delete :destroy, { id: @user_task.id, format: :json }
        expect(Task.find_by(id: @user_task.id)).to eq nil
      end

      it 'admin task' do
        expect { delete :destroy, { id: @admin_task.id, format: :json } }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'authorize admin' do
    before(:each) do
      @user_task = FactoryGirl.create(:task)

      @user = FactoryGirl.create(:user, :admin)
      @admin_task = FactoryGirl.create(:task)
      @user.tasks << @admin_task

      @request.session[:user_id] = @user
      @user_resource = @user_task.as_json(Task.as_json_include)
      @admin_resource = @admin_task.as_json(Task.as_json_include)
    end

    it 'index' do
      get :index, format: :json
      json = JSON.parse(response.body)
      expect(json['total_count']).to eq 2
      expect(json['collection'][0]['name']).to eq @admin_resource['name']
      expect(json['collection'][1]['name']).to eq @user_resource['name']
    end

    describe 'show' do
      it 'user task' do
        get :show, { id: @user_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @user_resource['name']
        expect(json['description']).to eq @user_resource['description']
        expect(json['state']).to eq @user_resource['state']
        expect(json['user']['email']).to eq @user_task.user.email
      end

      it 'admin task' do
        get :show, { id: @admin_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @admin_resource['name']
        expect(json['description']).to eq @admin_resource['description']
        expect(json['state']).to eq @admin_resource['state']
        expect(json['user']['email']).to eq @admin_task.user.email
      end
    end

    describe 'edit' do
      it 'user task' do
        get :edit, { id: @user_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @user_resource['name']
        expect(json['description']).to eq @user_resource['description']
      end

      it 'admin task' do
        get :edit, { id: @admin_task.id, format: :json }
        json = JSON.parse(response.body)
        expect(json['name']).to eq @admin_resource['name']
        expect(json['description']).to eq @admin_resource['description']
      end
    end

    it 'new' do
      get :new, { id: @user_task.id, format: :json }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'create' do
      post :create, { task: { name: 'test name',
                              description: 'test description',
                              user_id: @user_task.user_id }, format: :json }
      task = Task.last
      expect(task.name).to eq 'test name'
      expect(task.description).to eq 'test description'
      expect(task.user_id).to eq @user_task.user_id
      expect(task.state).to eq 'new'
    end

    describe 'update' do
      it 'user task' do
        put :update, { id: @user_task.id, task: { name: 'test name',
                                                  description: 'test description',
                                                  user_id: @user.id,
                                                  state: 'started' }, format: :json }
        @user_task.reload
        expect(@user_task.name).to eq 'test name'
        expect(@user_task.description).to eq 'test description'
        expect(@user_task.user_id).to eq @user_task.user_id
        expect(@user_task.state).to eq 'new'
      end

      it 'admin task' do
        put :update, { id: @admin_task.id, task: { name: 'test name',
                                                   description: 'test description',
                                                   user_id: @user_task.user_id,
                                                   state: 'started' }, format: :json }
        @admin_task.reload
        expect(@admin_task.name).to eq 'test name'
        expect(@admin_task.description).to eq 'test description'
        expect(@admin_task.user_id).to eq @user_task.user_id
        expect(@admin_task.state).to eq 'new'
      end

      it 'failure' do
        put :update, { id: @user_task.id, task: { name: '' }, format: :json }
        json = JSON.parse(response.body)
        expect(json['errors']['name']).to eq ['не может быть пустым']
      end

      it 'remove upload' do
        put :update, { id: @user_task.id, remove_upload: '1', task: { name: '' },
                       format: :json }
        @user_task.reload
        expect(@user_task.uploads.count).to eq 0
      end
    end

    describe 'destroy' do
      it 'user task' do
        delete :destroy, { id: @user_task.id, format: :json }
        expect(Task.find_by(id: @user_task.id)).to eq nil
      end

      it 'admin task' do
        delete :destroy, { id: @admin_task.id, format: :json }
        expect(Task.find_by(id: @admin_task.id)).to eq nil
      end
    end
  end
end
