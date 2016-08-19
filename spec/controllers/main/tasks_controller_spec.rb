require 'rails_helper'

RSpec.describe Main::TasksController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      FactoryGirl.create(:user_with_tasks)
      @user = FactoryGirl.create(:user, :admin)
      @task = FactoryGirl.create(:task)
      @user.tasks << @task
    end

    describe 'load tasks' do
      before(:each) do
        get :index, format: :json
        @json = JSON.parse(response.body)
        @resource = @task.as_json(Task.as_json_include)
      end

      it 'response body' do
        expect(@json['total_count']).to eq 51
        expect(@json['page']).to eq 1
        expect(@json['search']).to eq nil
        expect(@json['filter']).to eq nil
        expect(@json['page_size']).to eq 25
      end

      it 'resource' do
        expect(@json['collection'][0]['name']).to eq @resource['name']
        expect(@json['collection'][0]['user']['email']).to eq @resource['user']['email']
        expect(@json['collection'][0]['id']).to eq @resource['id']
      end
    end

    it 'search tasks' do
      get :index, { search: @task.name, format: :json }

      json = JSON.parse(response.body)
      expect(json['total_count']).to eq 1
      expect(json['page']).to eq 1
    end

    it 'page tasks' do
      get :index, { page: 3, format: :json }

      json = JSON.parse(response.body)
      expect(json['total_count']).to eq 51
      expect(json['page']).to eq 3
    end
  end
end
