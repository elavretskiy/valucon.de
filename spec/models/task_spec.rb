# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  state       :string           not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uploads     :string           default([]), is an Array
#

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validates presence' do
    before(:each) do
      task = Task.new
      task.save
      @errors = task.errors.full_messages.uniq
    end

    it 'name' do
      expect(@errors.include?('Название не может быть пустым')).to be true
    end

    it 'user' do
      expect(@errors.include?('Пользователь не может быть пустым')).to be true
    end
  end

  describe 'params' do
    before(:each) do
      @task = FactoryGirl.create(:task)
    end

    describe 'state machine' do
      it 'initial' do
        expect(@task.state).to eq 'new'
      end

      it 'to_started from new' do
        @task.update(state_event: :to_started)
        expect(@task.state).to eq 'started'
      end

      it 'to_started from finished' do
        @task.update_attribute(:state, :finished)
        @task.update(state_event: :to_started)
        expect(@task.state).to eq 'finished'
      end

      it 'to_finished from new' do
        @task.update(state_event: :to_finished)
        expect(@task.state).to eq 'new'
      end

      it 'to_finished from started' do
        @task.update_attribute(:state, :started)
        @task.update(state_event: :to_finished)
        expect(@task.state).to eq 'finished'
      end
    end

    describe 'default' do
      it 'uploads' do
        expect(@task.uploads).to eq []
      end
    end

    describe 'include' do
      it 'json' do
        json = @task.as_json(Task.as_json_include)
        expect(json['user']['email']).to eq @task.user.email
      end
    end
  end

  describe 'search' do
    before(:each) do
      @user = FactoryGirl.create(:user_with_tasks)
      @task = @user.tasks.take
    end

    it 'by tasks' do
      tasks = @user.tasks.search(@task.name)
      expect(@user.tasks.count).to eq 50
      expect(tasks.count).to eq 1
      expect(tasks.first.name).to eq @task.name
    end

    it 'by users' do
      tasks = @user.tasks.search(@user.email)
      expect(tasks.count).to eq 50
      expect(tasks.first.user.email).to eq @user.email
    end
  end

  describe 'scopes' do
    before(:each) do
      @user = FactoryGirl.create(:user_with_tasks)
    end

    describe 'by_state' do
      before(:each) do
        @started = @user.tasks.first
        @started.update_attribute(:state, 'started')

        @finished = @user.tasks.last
        @finished.update_attribute(:state, 'finished')
      end

      it 'started' do
        expect(@user.tasks.count).to eq 50
        expect(@user.tasks.by_state('new').count).to eq 48
      end

      it 'started' do
        expect(@user.tasks.by_state('started').count).to eq 1
        expect(@user.tasks.by_state('started').include?(@started)).to be true
      end

      it 'finished' do
        expect(@user.tasks.by_state('finished').count).to eq 1
        expect(@user.tasks.by_state('finished').include?(@finished)).to be true
      end
    end

    describe 'order' do
      it 'index' do
        expect(@user.tasks.first.id).to eq @user.tasks.first.id
        expect(@user.tasks.index.first.id).to eq @user.tasks.last.id
      end
    end
  end
end
